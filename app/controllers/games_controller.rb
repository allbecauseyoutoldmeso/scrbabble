class GamesController < ApplicationController
  before_action :authenticate_user
  before_action :load_game, only: [:show, :update]
  before_action :load_player, only: [:show]

  def index
    @user = current_user
  end

  def create
    player_1 = Player.create(user: other_user)
    player_2 = Player.create(user: current_user)
    game = Game.create(players: [player_1, player_2])
    redirect_to(game_path(game))
  end

  def update
    if params[:skip_turn]
      @game.skip_turn
    else
      @game.play_turn(data)
    end

    ActionCable.server.broadcast(
      'game_channel',
      shared: shared,
      confidential: {
        @game.player_1.id.to_s => confidential(@game.player_1),
        @game.player_2.id.to_s => confidential(@game.player_2),
      }
    )
  end

  private

  def shared
    render_to_string(partial: 'shared', locals:  { game: @game })
  end

  def confidential(player)
    render_to_string(
      partial: 'confidential',
      locals: {
        player: player,
        game: @game,
        alert: (@game.error_message if player.user == current_user)
      }
    )
  end

  def load_player
    @player = @game.players.find_by(user: current_user)
  end

  def load_game
    @game = current_user.games.find(params[:id])
  end

  def other_user
    User.find(game_params[:other_user_id])
  end

  def game_params
    params.require(:game).permit(:other_user_id)
  end

  def data
    JSON.parse(params[:data]).map(&:symbolize_keys)
  end
end
