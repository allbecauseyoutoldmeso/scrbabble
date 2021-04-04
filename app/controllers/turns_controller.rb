class TurnsController < ApplicationController
  def update
    if turn.player != player
      Turn.update(seen: true)
    end

    head :ok
  end

  private

  def player
    @player ||= Player.find(turn_params[:player_id])
  end

  def turn
    @turn ||= Turn.find(turn_params[:id])
  end

  def turn_params
    params.permit(:player_id, :id)
  end
end
