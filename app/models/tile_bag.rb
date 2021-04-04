class TileBag  < ActiveRecord::Base
  belongs_to :game
  has_many :tiles, as: :tileable
  after_create :create_tiles

  TILE_ATTRIBUTES = Array.new(9, { letter: 'A', points: 1 }) +
  Array.new(2, { letter: 'B', points: 3 }) +
  Array.new(2, { letter: 'C', points: 3 }) +
  Array.new(4, { letter: 'D', points: 2 }) +
  Array.new(12, { letter: 'E', points: 1 }) +
  Array.new(2, { letter: 'F', points: 4 }) +
  Array.new(3, { letter: 'G', points: 2 }) +
  Array.new(2, { letter: 'H', points: 4 }) +
  Array.new(9, { letter: 'I', points: 1 }) +
  Array.new(1, { letter: 'J', points: 8 }) +
  Array.new(1, { letter: 'K', points: 5 }) +
  Array.new(4, { letter: 'L', points: 1 }) +
  Array.new(2, { letter: 'M', points: 3 }) +
  Array.new(6, { letter: 'N', points: 1 }) +
  Array.new(8, { letter: 'O', points: 1 }) +
  Array.new(2, { letter: 'P', points: 3 }) +
  Array.new(1, { letter: 'Q', points: 10 }) +
  Array.new(6, { letter: 'R', points: 1 }) +
  Array.new(4, { letter: 'S', points: 1 }) +
  Array.new(6, { letter: 'T', points: 1 }) +
  Array.new(4, { letter: 'U', points: 1 }) +
  Array.new(2, { letter: 'V', points: 4 }) +
  Array.new(2, { letter: 'W', points: 4 }) +
  Array.new(1, { letter: 'X', points: 8 }) +
  Array.new(2, { letter: 'Y', points: 4 }) +
  Array.new(1, { letter: 'Z', points: 10 }) +
  Array.new(2, { letter: '?', points: 0, multipotent: true })

  def random_tile
    tiles[rand(tiles.count)]
  end

  def empty?
    tiles.empty?
  end

  private

  def create_tiles
    TILE_ATTRIBUTES.each do |attributes|
      Tile.create(attributes.merge(tileable: self))
    end
  end
end
