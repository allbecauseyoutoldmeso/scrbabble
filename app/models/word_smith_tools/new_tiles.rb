module WordSmithTools
  class NewTiles
    def initialize(data)
      @data = data
    end

    def assign_tiles
      parsed_data.each do |datum|
        datum[:square].tile = datum[:tile]
      end
    end

    def valid?
      (accross? && continuous_accross?) || (down? && continuous_down?)
    end

    def down?
      squares.map(&:x).uniq.count == 1
    end

    def accross?
      squares.map(&:y).uniq.count == 1
    end

    def squares
      @squares ||= parsed_data.map { |datum| datum[:square] }
    end

    private

    attr_reader :data

    def continuous_accross?
      (first_x..last_x).to_a == squares.map(&:x)
    end

    def continuous_down?
      (first_y..last_y).to_a == squares.map(&:y)
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

    def parsed_data
      @parsed_data ||= data.map do |datum|
        {
          square: Square.find(datum[:square_id]),
          tile: Tile.find(datum[:tile_id])
        }
      end
    end
  end
end
