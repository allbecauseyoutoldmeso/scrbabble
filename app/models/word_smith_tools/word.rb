module WordSmithTools
  class Word
    attr_reader :squares

    def initialize(squares)
      @squares = squares
    end

    def points
      word_tuples.reduce(:*) * letter_points
    end

    def tiles
      squares.map(&:tile)
    end

    private

    def word_tuples
      squares.map(&:word_tuple)
    end

    def letter_points
      squares.map do |square|
        square.tile.points * square.letter_tuple
      end.sum
    end
  end
end
