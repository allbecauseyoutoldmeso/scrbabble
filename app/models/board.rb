class Board < ActiveRecord::Base
  has_many :squares
  belongs_to :game
  after_create :create_squares

  BOARD_SIZE = 15

  def square(x, y)
    squares.find_by(x: x, y: y)
  end

  def rows
    Array.new(BOARD_SIZE) do |y|
      row(y)
    end
  end

  def row(y)
    squares.select do |square|
      square.y == y
    end
  end

  private

  def create_squares
    BOARD_SIZE.times do |x|
      BOARD_SIZE.times do |y|
        Square.create(x: x, y: y, board: self)
      end
    end
  end
end
