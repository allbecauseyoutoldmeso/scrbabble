class WordSmith
  def initialize(data:, board:)
    @data = data
    @board = board
  end

  def points
    tiles.map(&:points).sum
  end

  def valid?
    (accross? || down?) && all_squares.all?(&:tile)
  end

  private

  attr_reader :data, :board

  def tiles
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

  def squares
    @squares ||= Square.where(id: data.map { |datum| datum[:square_id] })
  end
end
