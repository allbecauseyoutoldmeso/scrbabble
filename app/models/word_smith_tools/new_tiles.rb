module WordSmithTools
  class NewTiles
    def initialize(data)
      @data = data
    end

    def down?
      squares.map(&:x).uniq.count == 1
    end

    def accross?
      squares.map(&:y).uniq.count == 1
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

    def tiles
      @tiles ||= parsed_data.map { |datum| datum[:tile] }
    end

    def squares
      @squares ||= parsed_data.map { |datum| datum[:square] }
    end

    def parsed_data
      @parsed_data ||= data.map do |datum|
        {
          square: Square.find(datum[:square_id]),
          tile: Tile.find(datum[:tile_id])
        }
      end
    end

    private

    attr_reader :data
  end
end
