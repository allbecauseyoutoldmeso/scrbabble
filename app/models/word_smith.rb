class WordSmith
  def initialize(data:, board:)
    @data = data
    @board = board
    place_tiles
  end

  def points
    all_tiles.map(&:points).sum
  end

  def valid?
    (accross? || down?) && all_squares.all?(&:tile)
  end

  def save
    squares.each(&:save)
  end

  private

  attr_reader :data, :board

  def place_tiles
    parsed_data.each do |datum|
      datum[:square].tile = datum[:tile]
    end
  end

  def all_tiles
    all_squares.map(&:tile)
  end

  def all_squares
    if accross?
      board.squares.where(y: first_y, x: first_x..last_x)
    else
      board.squares.where(x: first_x, y: first_y..last_y)
    end
  end

  def down?
    squares.map(&:y).uniq.count > 1
  end

  def accross?
    squares.map(&:x).uniq.count > 1
  end

  def first_x
    squares.map(&:x).min
  end

  def last_x
    squares.map(&:x).max
  end

  def first_y
    squares.map(&:y).min
  end

  def last_y
    squares.map(&:y).max
  end

  def tiles
    @tiles ||= parsed_data.map { |datum| datum[:tile] }
  end

  def squares
    @squares ||= parsed_data.map { |datum| datum[:square] }
  end

  def parsed_data
    @parsed_data ||= data.map do |datum|
      {
        square: Square.find(datum[:square_id]),
        tile: Tile.find(datum[:tile_id])
      }
    end
  end
end
