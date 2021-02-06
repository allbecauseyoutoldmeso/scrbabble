require 'rails_helper'

describe 'Board' do
  describe '#spaces' do
    let(:game) { create(:game) }
    let(:player) { create(:player, game: game) }
    let(:tile_rack) { create(:tile_rack, player: player) }
    let!(:tile_1) { create(:tile, tileable: tile_rack) }
    let!(:tile_2) { create(:tile, tileable: tile_rack) }

    it 'returns remaining spaces' do
      expect(tile_rack.spaces).to eq(TileRack::MAXIMUM_TILES - 2)
    end
  end
end
