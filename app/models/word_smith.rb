class WordSmith
  class InvalidWord < StandardError
  end

  delegate :inactivate_premiums, :inactivate_blanks, to: :new_placements

  def initialize(data:, board:)
    @new_placements = WordSmithTools::NewPlacements.new(data)
    @board = board
  end

  def assign_tiles
    ActiveRecord::Base.transaction do
      new_placements.assign_tiles
      raise(InvalidWord.new) unless valid?
    end
  end

  def points
    words.map(&:points).sum + bonus
  end

  private

  attr_reader :new_placements, :board

  def bonus
    new_placements.tiles.count == TileRack::MAXIMUM_TILES ? 50 : 0
  end

  def valid?
    new_placements.single_axis? &&
    new_tiles_continuous? &&
    words_use_old_tiles? &&
    words_valid?
  end

  def new_tiles_continuous?
    board.squares.where(
      x: new_placements.first_x..new_placements.last_x,
      y: new_placements.first_y..new_placements.last_y
    ).all?(&:tile)
  end

  def words_use_old_tiles?
    if old_tiles.empty?
      new_placements.squares.include?(board.middle_square)
    else
      words.any? do |word|
        (word.tiles & old_tiles).any?
      end
    end
  end

  def words_valid?
    words.all?(&:valid?)
  end

  def old_tiles
    board.tiles - new_placements.tiles
  end

  def words
    @words ||= [primary_word] + secondary_words
  end

  def primary_word
    if accross?
      WordSmithTools::Word.new(accross_squares(primary_square))
    else
      WordSmithTools::Word.new(down_squares(primary_square))
    end
  end

  def secondary_words
    secondary_word_candidates.select do |word|
      word.squares.length > 1
    end
  end

  def secondary_word_candidates
    new_placements.squares.map do |square|
      if accross?
        WordSmithTools::Word.new(down_squares(square))
      else
        WordSmithTools::Word.new(accross_squares(square))
      end
    end
  end

  def accross?
    if new_placements.tiles.count == 1
      accross_squares(primary_square).count > 1
    else
      new_placements.accross?
    end
  end

  # think about readable way to dry all this up

  def primary_square
    new_placements.squares.first
  end

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
    ).reverse
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
