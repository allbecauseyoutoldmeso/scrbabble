class TileRack  < ActiveRecord::Base
  belongs_to :player
  has_many :tiles, as: :tileable

  MAXIMUM_TILES = 7

  def spaces
    MAXIMUM_TILES - tiles.count
  end
end
