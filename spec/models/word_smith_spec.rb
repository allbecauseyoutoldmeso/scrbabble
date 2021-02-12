require 'rails_helper'

describe 'WordSmith' do
  let(:game) { create(:game) }
  let(:board) { game.board }
  let(:tile_bag) { game.tile_bag }
  let(:tiles) { tile_bag.tiles.first(3) }

  let(:data) do
    tiles.map do |tile|
      { tile_id: tile.id, square_id: tile.tileable.id }
    end
  end

  let(:word_smith) { WordSmith.new(data: data, board: board) }

  describe '#points' do
    context 'accross word' do
      it 'returns sum of points for all tiles' do
        tiles.each_with_index do |tile, index|
          tile.update(tileable: board.square(1, index))
        end

        expect(word_smith.points).to eq(tiles.map(&:points).sum)
      end
    end

    context 'down word' do
      it 'returns sum of points for all tiles' do
        tiles.each_with_index do |tile, index|
          tile.update(tileable: board.square(index, 1))
        end

        expect(word_smith.points).to eq(tiles.map(&:points).sum)
      end
    end
  end

  describe '#valid' do
    context 'tiles are continuous and on single axis' do
      it 'returns true' do
        tiles.each_with_index do |tile, index|
          tile.update(tileable: board.square(index, 1))
        end

        expect(word_smith.valid?).to eq true
      end
    end

    context 'tiles are not continuous' do
      it 'returns false' do
        tiles.each_with_index do |tile, index|
          tile.update(tileable: board.square(1, index * 2))
        end

        expect(word_smith.valid?).to eq false
      end
    end

    context 'tiles are not on single axis' do
      it 'returns false' do
        tiles.each_with_index do |tile, index|
          tile.update(tileable: board.square(index, index))
        end

        expect(word_smith.valid?).to eq false
      end
    end
  end
end
