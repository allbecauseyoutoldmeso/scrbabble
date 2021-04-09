class GamesController < ApplicationController
  before_action :authenticate_user
  before_action :load_game, only: [:show, :update]
  before_action :load_player, only: [:show]

  def index
    @user = current_user
  end

  def create
    # issue with csrf token because form sent via action cable
    game = create_game
    invitation.update(accepted: true)
    update_invitations(invitation.inviter)
    update_games(invitation.inviter)
    redirect_to(game_path(game))
  end

  def show
    if latest_turn.present? && latest_turn.player.user != current_user
      latest_turn.update(seen: true)
    end
  end

  def update
    if params[:skip_turn]
      @game.skip_turn(tile_ids)
    else
      @game.play_turn(data)
    end

    ActionCable.server.broadcast(
      'game_channel',
      shared: shared,
      confidential: {
        @game.player_1.id.to_s => confidential(@game.player_1),
        @game.player_2.id.to_s => confidential(@game.player_2)
      }
    )
  end

  private

  def update_games(other_user)
    ActionCable.server.broadcast(
      'invitation_channel',
      games: {
        current_user.id.to_s => games(current_user),
        other_user.id.to_s => games(other_user)
      }
    )
  end

  def games(user)
    render_to_string(partial: 'games/ongoing_games', locals:  { user: user })
  end

  def create_game
    player_1 = Player.create(user: invitation.invitee)
    player_2 = Player.create(user: invitation.inviter)
    Game.create(players: [player_1, player_2], current_player: player_1)
  end

  def latest_turn
    @latest_turn || @game.latest_turn
  end

  def shared
    render_to_string(partial: 'shared', locals:  { game: @game })
  end

  def confidential(player)
    render_to_string(
      partial: 'confidential',
      locals: {
        player: player,
        alert: (@game.error_message if player.user == current_user),
        tile_bag: @game.tile_bag
      }
    )
  end

  def load_player
    @player = @game.players.find_by(user: current_user)
  end

  def load_game
    @game = current_user.games.find(params[:id])
  end

  def invitation
    Invitation.find(game_params[:invitation_id])
  end

  def game_params
    params.require(:game).permit(:invitation_id)
  end

  def tile_ids
    JSON.parse(params[:tile_ids]) if params[:tile_ids]
  end

  def data
    JSON.parse(params[:data]).map(&:symbolize_keys)
  end
end
