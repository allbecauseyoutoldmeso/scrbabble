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

  describe '#play_tile' do
    let(:x) { 5 }
    let(:y) { 10 }
    let(:board) { game.board }
    let(:square) { board.square(x, y) }
    let(:player) { game.player_1 }
    let(:tile_rack) { player.tile_rack}
    let(:tile) { tile_rack.tiles.first }

    before do
      game.assign_tiles(player)
    end

    it 'adds tile to square' do
      game.play_tile(x, y, tile)
      expect(square.tile).to eq(tile)
    end

    it 'removes tile from tile rack' do
      expect {
        game.play_tile(x, y, tile)
      }.to change {
        tile_rack.tiles.count
      }.by(-1)
    end
  end
end
