require 'rails_helper'

describe 'TileBag' do
  let(:game) { create(:game) }
  let(:tile_bag) { create(:tile_bag, game: game) }

  describe '#create' do
    it 'has tiles' do
      expect(tile_bag.tiles.map { |square|
        square.attributes.symbolize_keys.slice(:letter, :points)
      }).to eq(TileBag::TILE_ATTRIBUTES)
    end
  end

  describe '#random_tiles' do
    it 'returns specified number of tiles' do
      expect(tile_bag.random_tiles(5).length).to eq(5)
    end
  end
end
