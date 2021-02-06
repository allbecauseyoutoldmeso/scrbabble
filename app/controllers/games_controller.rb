class GamesController < ApplicationController
  before_action :load_game

  def show
  end

  private

  def load_game
    @game = Game.find(params[:id])
  end
end
