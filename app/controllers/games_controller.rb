class GamesController < ApplicationController
  before_action :load_game

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
