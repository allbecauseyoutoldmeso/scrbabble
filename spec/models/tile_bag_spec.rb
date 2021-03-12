require 'rails_helper'

describe 'TileBag' do
  let(:game) { create(:game) }
  let(:tile_bag) { create(:tile_bag, game: game) }

  describe '#create' do
    it 'has tiles' do
      expect(tile_bag.tiles.map { |square|
        square.attributes.symbolize_keys.slice(:letter, :points)
      }).to eq(TileBag::TILE_ATTRIBUTES.map { |attributes|
        attributes.slice(:letter, :points)
      })
    end
  end

  describe '#random_tile' do
    it 'returns a tie' do
      expect(tile_bag.random_tile).to be_a(Tile)
    end
  end
end
