class Player < ActiveRecord::Base
  belongs_to :game
  has_one :tile_rack
  has_many :words
  after_create :create_tile_rack
  delegate :tiles, :spaces, to: :tile_rack

  private

  def create_tile_rack
    TileRack.create(player: self)
  end
end
