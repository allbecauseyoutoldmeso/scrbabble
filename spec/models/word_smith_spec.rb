require 'rails_helper'

describe 'WordSmith' do
  let(:game) { create(:game) }
  let(:board) { game.board }
  let(:tile_bag) { game.tile_bag }
  let(:tiles) { tile_bag.tiles.first(3) }

  let(:squares) do
    3.times.map { |y| board.square(0, y) }
  end

  let(:data) do
    tiles.zip(squares).map do |array|
      { tile_id: array[0].id, square_id: array[1].id }
    end
  end

  let(:word_smith) { WordSmith.new(data: data, board: board) }

  describe '#valid?' do
    context 'tiles are continuous and on single axis' do
      it 'returns true' do
        expect(word_smith.valid?).to eq true
      end
    end

    context 'tiles are not continuous' do
      let(:squares) do
        3.times.map { |y| board.square(0, y * y) }
      end

      it 'returns false' do
        expect(word_smith.valid?).to eq false
      end
    end

    context 'tiles are not on single axis' do
      let(:squares) do
        3.times.map { |y,| board.square(y, y) }
      end

      it 'returns false' do
        expect(word_smith.valid?).to eq false
      end
    end
  end

  describe '#assign_tiles' do
    it 'assigns tiles to squares' do
      word_smith.assign_tiles
      expect(tiles.all? { |tile|
        tile.reload.tileable.is_a?(Square)
      }).to eq(true)
    end
  end

  describe '#points' do
    it 'returns sum of points for all tiles' do
      word_smith.assign_tiles
      expect(word_smith.points).to eq(tiles.map(&:points).sum)
    end
  end
end
