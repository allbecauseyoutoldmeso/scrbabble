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

    def valid?
      dictionary_client.valid_scrabble_word?
    end

    private

    def dictionary_client
      DictionaryClient.new(word)
    end

    def word
      tiles.map(&:letter).join.downcase
    end

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
