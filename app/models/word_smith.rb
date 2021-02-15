class WordSmith
  delegate :assign_tiles, to: :new_tiles

  def initialize(data:, board:)
    @new_tiles = WordSmithTools::NewTiles.new(data)
    @board = board
  end

  def words
    @words ||= []
  end

  def valid?
    new_tiles.valid?
    # && new_tiles_join_old_tiles?
    # && words_in_dictionary?
  end

  def points
    all_tiles.map(&:points).sum
  end

  private

  attr_reader :new_tiles, :board

  def all_tiles
    all_squares.map(&:tile)
  end

  def all_squares
    if new_tiles.accross?
      board.squares.where(y: new_tiles.first_y, x: first_x..last_x)
    else
      board.squares.where(x: new_tiles.first_x, y: first_y..last_y)
    end
  end

  # think about readable way to dry these up
  def first_x
    x = new_tiles.first_x
    while x - 1 >= 0 && board.square(x - 1, new_tiles.first_y).tile.present? do
      x -= 1
    end
    x
  end

  def last_x
    x = new_tiles.last_x
    while x + 1 < Board::BOARD_SIZE && board.square(x + 1, new_tiles.first_y).tile.present? do
      x += 1
    end
    x
  end

  def first_y
    y = new_tiles.first_y
    while y - 1 >= 0 && board.square(new_tiles.first_x, y - 1).tile.present? do
      y -= 1
    end
    y
  end

  def last_y
    y = new_tiles.last_y
    while y + 1 < Board::BOARD_SIZE && board.square(new_tiles.first_x, y + 1).tile.present? do
      y += 1
    end
    y
  end
end
