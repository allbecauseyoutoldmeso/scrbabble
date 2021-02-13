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

  describe '#add_points' do
    it 'increases points by specified number' do
      player.add_points(10)
      expect(player.reload.points).to eq(10)
    end
  end
end
