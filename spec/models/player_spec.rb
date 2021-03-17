require 'rails_helper'

describe 'Player' do
  let(:game) { create(:game) }
  let(:player) { create(:player, game: game) }

  describe '#create' do
    it 'has tile_rack' do
      expect(player.tile_rack).to be_present
    end
  end

  describe '#tiles' do
    it 'returns tile rack tiles' do
      expect(player.tiles).to eq(player.tile_rack.tiles)
    end
  end

  describe '#spaces' do
    it 'returns tile rack tiles' do
      expect(player.spaces).to eq(player.tile_rack.spaces)
    end
  end

  describe '#points' do
    let!(:turn_1) { create(:turn, game: game, player: player, points: 10) }
    let!(:turn_2) { create(:turn, game: game, player: player, points: 5) }

    it 'returns sum of points for all turns' do
      expect(player.points).to eq(15)
    end
  end
end
