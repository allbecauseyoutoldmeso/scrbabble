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

  describe '#play_turn' do
    let(:player) { game.player_1 }
    let(:tile_rack ) { player.tile_rack }
    let(:board) { game.board }
    let(:tile_1) { tile_rack.tiles[0] }
    let(:tile_2) { tile_rack.tiles[1] }
    let(:square_1) { board.squares[0] }
    let(:square_2) { board.squares[1] }

    let(:data) do
      [
        {
          tile_id: tile_1.id,
          square_id: square_1.id
        },
        {
          tile_id: tile_2.id,
          square_id: square_2.id
        }
      ]
    end

    it "assigns tiles to squares" do
      game.play_turn(data)
      expect(tile_1.reload.tileable).to eq square_1
      expect(tile_2.reload.tileable).to eq square_2
    end
  end
end
