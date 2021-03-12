class TilesController < ApplicationController
  def update
    tile = Tile.find(tile_params[:id])
    tile.update(letter: tile_params[:letter])
    render partial: 'games/tile', locals: { tile: tile, draggable: true }
  end

  private

  def tile_params
    params.permit(:letter, :id)
  end
end
