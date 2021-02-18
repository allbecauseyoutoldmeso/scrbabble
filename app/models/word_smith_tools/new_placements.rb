module WordSmithTools
  class NewPlacements
    def initialize(data)
      @data = data
    end

    def assign_tiles
      parsed_data.each do |datum|
        datum[:square].tile = datum[:tile]
      end
    end

    def single_axis?
      down? || accross?
    end

    def down?
      squares.map(&:x).uniq.count == 1
    end

    def accross?
      squares.map(&:y).uniq.count == 1
    end

    # DRY up?
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

    private

    attr_reader :data

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
