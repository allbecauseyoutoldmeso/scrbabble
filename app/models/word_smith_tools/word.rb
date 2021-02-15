module WordSmithTools
  class Word
    def initialize(squares)
      @squares = squares
    end

    def points
      tiles.map(&:points).sum
    end

    private

    def tiles
      squares.map(&:tile)
    end

    attr_reader :squares
  end
end
