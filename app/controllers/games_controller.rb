class GamesController < ApplicationController
  before_action :authenticate_user
  before_action :load_game, only: [:show, :update]

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

  def show
    @player = @game.players.find_by(user: current_user)
  end

  def update
    @game.play_turn(data)
    @player = @game.players.find_by(user: current_user)
    render :show
  end

  private

  def other_user
    User.find(game_params[:other_user_id])
  end

  def game_params
    params.require(:game).permit(:other_user_id)
  end

  def data
    # should be able to use strong params
    JSON.parse(params[:data]).map(&:symbolize_keys)
  end

  def load_game
    @game = current_user.games.find(params[:id])
  end
end
