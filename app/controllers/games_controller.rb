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
    @game.play_word(word_data)
    render partial: 'board', locals: { board: @game.board }
  end

  private

  def word_data
    JSON.parse(params[:word_data]).map(&:symbolize_keys)
  end

  def load_game
    @game = Game.find(params[:id])
  end
end
