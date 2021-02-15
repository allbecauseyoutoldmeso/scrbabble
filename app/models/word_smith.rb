class WordSmith
  delegate :assign_tiles, to: :new_tiles

  def initialize(data:, board:)
    @new_tiles = WordSmithTools::NewTiles.new(data)
    @board = board
  end

  def points
    words.map(&:points).sum
  end

  def valid?
    new_tiles.valid?
    # && new_tiles_join_old_tiles?
    # && words_in_dictionary?
  end

  private

  attr_reader :new_tiles, :board

  def words
    [primary_word] + secondary_words
  end

  def primary_word
    if new_tiles.accross?
      WordSmithTools::Word.new(accross_squares(new_tiles.squares.first))
    else
      WordSmithTools::Word.new(down_squares(new_tiles.squares.first))
    end
  end

  def secondary_words
    new_tiles.squares.map do |square|
      if new_tiles.accross?
        WordSmithTools::Word.new(down_squares(square))
      else
        WordSmithTools::Word.new(accross_squares(square))
      end
    end.select do |word|
      word.squares.length > 1
    end
  end

  # think about readable way to dry all this up

  def accross_squares(initial_square)
    x = initial_square.x
    y = initial_square.y

    board.squares.where(
      x: first_x(x, y)..last_x(x, y),
      y: y
    )
  end

  def down_squares(initial_square)
    x = initial_square.x
    y = initial_square.y

    board.squares.where(
      x: x,
      y: first_y(x, y)..last_y(x, y)
    )
  end

  def first_x(x, y)
    while x - 1 >= 0 && board.square(x - 1, y).tile.present? do
      x -= 1
    end
    x
  end

  def last_x(x, y)
    while x + 1 < Board::BOARD_SIZE && board.square(x + 1, y).tile.present? do
      x += 1
    end
    x
  end

  def first_y(x, y)
    while y - 1 >= 0 && board.square(x, y - 1).tile.present? do
      y -= 1
    end
    y
  end

  def last_y(x, y)
    while y + 1 < Board::BOARD_SIZE && board.square(x, y + 1).tile.present? do
      y += 1
    end
    y
  end
end
