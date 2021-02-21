class GamesController < ApplicationController
  before_action :authenticate_user
  before_action :load_game, only: [:show, :update, :tile_rack]
  before_action :load_player, only: [:show, :tile_rack]

  def index
    @games = current_user.games
  end

  def new
    @other_users = current_user.other_users
  end

  def create
    player_1 = Player.create(user: other_user)
    player_2 = Player.create(user: current_user)
    game = Game.create(players: [player_1, player_2])
    redirect_to(game_path(game))
  end

  def update
    @game.play_turn(data)

    ActionCable.server.broadcast(
      'game_channel',
      shared: (render partial: 'shared', locals:  { game: @game })
    )
  end

  def tile_rack
    render partial: 'tile_rack', locals:  { player: @player }
  end

  private

  def other_user
    User.find(game_params[:other_user_id])
  end

  def load_player
    @player = @game.players.find_by(user: current_user)
  end

  def load_game
    @game = current_user.games.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:other_user_id)
  end

  def data
    JSON.parse(params[:data]).map(&:symbolize_keys)
  end
end
