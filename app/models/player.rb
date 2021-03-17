class Player < ActiveRecord::Base
  belongs_to :game, optional: true
  belongs_to :user
  has_one :tile_rack
  has_many :words
  has_many :turns

  after_create :create_tile_rack

  delegate :tiles, :spaces, to: :tile_rack
  delegate :name, to: :user

  def is_current_player?
    game.current_player == self
  end

  def points
    turns.map(&:points).sum
  end

  private

  def create_tile_rack
    TileRack.create(player: self)
  end
end
