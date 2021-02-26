class Board < ActiveRecord::Base
  has_many :squares
  has_many :tiles, through: :squares
  belongs_to :game
  after_create :create_squares
  after_create :create_premiums

  BOARD_SIZE = 15

  PREMIUM_ATTRIBUTES = [
    { target: :word, tuple: 2, x: 1, y: 1 },
    { target: :word, tuple: 2, x: 2, y: 2 },
    { target: :word, tuple: 2, x: 3, y: 3 },
    { target: :word, tuple: 2, x: 4, y: 4 },
    { target: :word, tuple: 2, x: 7, y: 7 },
    { target: :word, tuple: 2, x: 10, y: 10 },
    { target: :word, tuple: 2, x: 11, y: 11 },
    { target: :word, tuple: 2, x: 12, y: 12 },
    { target: :word, tuple: 2, x: 13, y: 13 },
    { target: :word, tuple: 2, x: 1, y: 13 },
    { target: :word, tuple: 2, x: 2, y: 12 },
    { target: :word, tuple: 2, x: 3, y: 11 },
    { target: :word, tuple: 2, x: 4, y: 10 },
    { target: :word, tuple: 2, x: 10, y: 4 },
    { target: :word, tuple: 2, x: 11, y: 3 },
    { target: :word, tuple: 2, x: 12, y: 2 },
    { target: :word, tuple: 2, x: 13, y: 1 },
    { target: :word, tuple: 3, x: 0, y: 0 },
    { target: :word, tuple: 3, x: 0, y: 14 },
    { target: :word, tuple: 3, x: 14, y: 0 },
    { target: :word, tuple: 3, x: 14, y: 14 },
    { target: :word, tuple: 3, x: 0, y: 7 },
    { target: :word, tuple: 3, x: 7, y: 0 },
    { target: :word, tuple: 3, x: 14, y: 7 },
    { target: :word, tuple: 3, x: 7, y: 14 },
    { target: :letter, tuple: 2, x: 3, y: 0 },
    { target: :letter, tuple: 2, x: 12, y: 0 },
    { target: :letter, tuple: 2, x: 0, y: 3 },
    { target: :letter, tuple: 2, x: 0, y: 12 },
    { target: :letter, tuple: 2, x: 14, y: 3 },
    { target: :letter, tuple: 2, x: 14, y: 12 },
    { target: :letter, tuple: 2, x: 3, y: 14 },
    { target: :letter, tuple: 2, x: 12, y: 14 },
    { target: :letter, tuple: 2, x: 6, y: 2 },
    { target: :letter, tuple: 2, x: 8, y: 2 },
    { target: :letter, tuple: 2, x: 7, y: 3 },
    { target: :letter, tuple: 2, x: 2, y: 6 },
    { target: :letter, tuple: 2, x: 2, y: 8 },
    { target: :letter, tuple: 2, x: 3, y: 7 },
    { target: :letter, tuple: 2, x: 12, y: 6 },
    { target: :letter, tuple: 2, x: 12, y: 8 },
    { target: :letter, tuple: 2, x: 11, y: 7 },
    { target: :letter, tuple: 2, x: 6, y: 12 },
    { target: :letter, tuple: 2, x: 8, y: 12 },
    { target: :letter, tuple: 2, x: 7, y: 11 },
    { target: :letter, tuple: 2, x: 6, y: 6 },
    { target: :letter, tuple: 2, x: 8, y: 8 },
    { target: :letter, tuple: 2, x: 6 , y: 8 },
    { target: :letter, tuple: 2, x: 8 , y: 6 },
    { target: :letter, tuple: 3, x: 5, y: 1 },
    { target: :letter, tuple: 3, x: 9, y: 1 },
    { target: :letter, tuple: 3, x: 5, y: 13 },
    { target: :letter, tuple: 3, x: 9, y: 13 },
    { target: :letter, tuple: 3, x: 1, y: 5 },
    { target: :letter, tuple: 3, x: 5, y: 5 },
    { target: :letter, tuple: 3, x: 13, y: 5 },
    { target: :letter, tuple: 3, x: 9, y: 5 },
    { target: :letter, tuple: 3, x: 1, y: 9 },
    { target: :letter, tuple: 3, x: 5, y: 9 },
    { target: :letter, tuple: 3, x: 13, y: 9 },
    { target: :letter, tuple: 3, x: 9, y: 9 }
  ]

  def middle_square
    square(BOARD_SIZE/2, BOARD_SIZE/2)
  end

  def square(x, y)
    squares.find_by(x: x, y: y)
  end

  def rows
    Array.new(BOARD_SIZE) do |y|
      row(y)
    end
  end

  private

  def row(y)
    squares.select do |square|
      square.y == y
    end
  end

  def create_squares
    BOARD_SIZE.times do |x|
      BOARD_SIZE.times do |y|
        Square.create(x: x, y: y, board: self)
      end
    end
  end

  def create_premiums
    PREMIUM_ATTRIBUTES.each do |attributes|
      square = square(attributes[:x], attributes[:y])

      Premium.create(
        target: attributes[:target],
        tuple: attributes[:tuple],
        square: square
      )
    end
  end
end
