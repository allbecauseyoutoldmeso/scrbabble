require 'rails_helper'

describe 'Game' do
  let(:game) { create(:game) }

  describe '#create' do
    it 'has board' do
      expect(game.board).to be_present
    end

    it 'has tile_bag' do
      expect(game.tile_bag).to be_present
    end

    it 'has players' do
      expect(game.players.count).to eq(2)
    end

    it 'has current player' do
      expect(game.current_player).to be_present
    end
  end

  describe '#assign_tiles' do
    let(:player) { game.player_1 }
    let(:tile_rack) { player.tile_rack}
    let(:tile_bag) { game.tile_bag }

    before do
      tile_rack.tiles.each { |tile|
        tile.update(tileable: tile_bag)
      }
    end

    it 'assigns tiles to player' do
      expect {
        game.assign_tiles(player)
      }.to change {
        tile_rack.tiles.count
      }.by(TileRack::MAXIMUM_TILES)
    end

    it 'removes tiles from tile rack' do
      expect {
        game.assign_tiles(player)
      }.to change {
        tile_bag.tiles.count
      }.by(-TileRack::MAXIMUM_TILES)
    end
  end
end
