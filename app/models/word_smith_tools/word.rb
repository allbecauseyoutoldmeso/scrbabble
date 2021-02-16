module WordSmithTools
  class Word
    attr_reader :squares

    def initialize(squares)
      @squares = squares
    end

    def points
      tiles.map(&:points).sum
    end

    def tiles
      squares.map(&:tile)
    end
  end
end
