class GamesController < ApplicationController
  before_action :load_game, only: [:show, :update]

  def index
    @games = Game.all
  end

  def create
    game = Game.create
    redirect_to(game_path(game))
  end

  def show
  end

  def update
    @game.play_turn(data)
    render :show
  end

  private

  def data
    JSON.parse(params[:data]).map(&:symbolize_keys)
  end

  def load_game
    @game = Game.find(params[:id])
  end
end
