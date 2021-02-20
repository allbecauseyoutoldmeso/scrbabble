require 'rails_helper'

describe 'Game' do
  let(:player_1) { create(:player) }
  let(:player_2) { create(:player) }
  let(:game) { create(:game, players: [player_1, player_2]) }

  describe '#create' do
    it 'has board' do
      expect(game.board).to be_present
    end

    it 'has tile_bag' do
      expect(game.tile_bag).to be_present
    end

    it 'has current player' do
      expect(game.current_player).to eq(player_1)
    end
  end

  describe '#play_turn' do
    let(:board) { game.board }
    let(:tiles) { player_1.tiles.first(3) }

    let(:data) do
      tiles.zip(squares).map do |array|
        { tile_id: array[0].id, square_id: array[1].id }
      end
    end

    before do
      game.play_turn(data)
    end

    context 'valid word' do
      let(:squares) do
        3.times.map { |y| board.square(1, y + 2) }
      end

      it 'assigns tiles to squares' do
        expect(
          tiles.all? { |tile| tile.reload.tileable.is_a?(Square) }
        ).to eq(true)
      end

      it 'assigns points to current player' do
        expect(player_1.points).to eq(tiles.map(&:points).sum)
      end

      it 'assigns new tiles to current player' do
        expect(
          player_1.tiles.count
        ).to eq(TileRack::MAXIMUM_TILES)
      end

      it 'toggles current player' do
        expect(game.current_player).to eq player_2
      end

      context 'squares have premiums' do
        let(:squares) do
          3.times.map { |x| board.square(x + 1, 0) }
        end

        it 'invalidates premiums' do
          expect(board.square(3, 0).premium).not_to be_active
        end
      end
    end

    context 'invalid word' do
      let(:squares) do
        3.times.map { |y| board.square(y, y) }
      end

      it 'does not assign tiles to squares' do
        expect(
          tiles.all? { |tile| tile.reload.tileable.is_a?(TileRack) }
        ).to eq(true)
      end

      it 'does not assign points to current player' do
        expect(player_1.points).to eq(0)
      end

      it 'does not toggle current player' do
        expect(game.current_player).to eq player_1
      end

      it 'does not invalidate premiums' do
        expect(board.square(0, 0).premium).to be_active
      end
    end
  end
end
