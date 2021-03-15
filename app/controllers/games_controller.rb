class GamesController < ApplicationController
  before_action :authenticate_user

  before_action :load_game, only: [
    :show,
    :update,
    :update_shared,
    :update_tile_rack
  ]

  def index
    @user = current_user
  end

  def create
    player_1 = Player.create(user: other_user)
    player_2 = Player.create(user: current_user)
    game = Game.create(players: [player_1, player_2])
    redirect_to(game_path(game))
  end

  def show
    @player = @game.players.find_by(user: current_user)
  end

  def update
    @game.play_turn(data)

    ActionCable.server.broadcast(
      'game_channel',
      alert:  @game.status_message[:alert],
      player_ids: @game.status_message[:player_ids].map(&:to_s)
    )
  end

  def update_shared
    ActionCable.server.broadcast(
      'game_channel',
      shared: (render partial: 'shared', locals:  { game: @game })
    )
  end

  def update_tile_rack
    player = params[:player] == '1' ? @game.player_1 : @game.player_2

    ActionCable.server.broadcast(
      'game_channel',
      tile_rack: (render partial: 'tile_rack', locals:  { player: player }),
      player_id: player.id
    )
  end

  private

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
