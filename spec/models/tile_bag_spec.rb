require 'spec_helper'

describe 'TileBag' do
  describe '#create' do
    let(:game) { create(:game) }
    let(:tile_bag) { create(:tile_bag, game: game) }

    it 'has tiles' do
      expect(tile_bag.tiles.map { |square|
        square.attributes.symbolize_keys.slice(:letter, :points)
      }).to eq(TileBag::TILE_ATTRIBUTES)
    end
  end
end
