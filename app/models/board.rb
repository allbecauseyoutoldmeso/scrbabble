class Board < ActiveRecord::Base
  has_many :squares
  belongs_to :game
  after_create :create_squares

  BOARD_SIZE = 15

  def square(x, y)
    squares.find { |square| square.x == x && square.y == y}
  end

  # def columns
  #   Array.new(15) do |y|
  #     column(y)
  #   end
  # end
  #
  # def rows
  #   Array.new(15) do |x|
  #     row(x)
  #   end
  # end
  #
  # def row(x)
  #   squares.select do |square|
  #     square.x == x
  #   end
  # end
  #
  # def column(y)
  #   squares.select do |square|
  #     square.y == y
  #   end
  # end

  private

  def create_squares
    BOARD_SIZE.times do |x|
      BOARD_SIZE.times do |y|
        Square.create(x: x, y: y, board: self)
      end
    end
  end
end
