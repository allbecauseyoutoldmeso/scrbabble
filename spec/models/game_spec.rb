require 'rails_helper'

describe 'Game' do
  let(:player_1) { create(:player) }
  let(:player_2) { create(:player) }
  let!(:game) { create(:game, players: [player_1, player_2]) }

  before do
    stub_request(:get, %r{http://api.wordnik.com})
      .to_return(body: { value: 9 }.to_json)
  end

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
      tiles.first.update(multipotent: true)
      game.play_turn(data)
    end

    context 'valid word' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + y)
        end
      end

      it 'assigns tiles to squares' do
        expect(
          tiles.all? { |tile| tile.reload.tileable.is_a?(Square) }
        ).to eq(true)
      end

      it 'assigns points to current player' do
        expect(player_1.points).to eq(tiles.map(&:points).sum * 2)
      end

      it 'assigns new tiles to current player' do
        expect(
          player_1.tiles.count
        ).to eq(TileRack::MAXIMUM_TILES)
      end

      it 'toggles current player' do
        expect(game.current_player).to eq player_2
      end

      it 'invalidates premiums' do
        expect(board.middle_square.premium).not_to be_active
      end

      it 'invalidates multipotents' do
        expect(tiles.any? { |tile| tile.reload.multipotent? }).to eq(false)
      end

      it 'sets status message' do
        expect(game.status_message).to eq ({
          player_ids: [player_1.id, player_2.id],
          alert: I18n.t(
            'games.status_messages.points_update',
            player: player_1.name,
            points: player_1.points
          )
        })
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

      it 'does not invalidate multipotents' do
        expect(tiles.any? { |tile| tile.reload.multipotent? }).to eq(true)
      end

      it 'sets status message' do
        expect(game.status_message).to eq (
          {
            player_ids: [player_1.id],
            alert: I18n.t('games.status_messages.invalid_word')
          }
        )
      end
    end
  end
end
