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
    end

    context 'valid word' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + y)
        end
      end

      it 'assigns tiles to squares' do
        game.play_turn(data)

        expect(
          tiles.all? { |tile| tile.reload.tileable.is_a?(Square) }
        ).to eq(true)
      end

      it 'assigns points to current player' do
        game.play_turn(data)
        expect(player_1.points).to eq(tiles.map(&:points).sum * 2)
      end

      it 'assigns new tiles to current player' do
        game.play_turn(data)

        expect(
          player_1.tiles.count
        ).to eq(TileRack::MAXIMUM_TILES)
      end

      it 'toggles current player' do
        game.play_turn(data)
        expect(game.current_player).to eq player_2
      end

      it 'invalidates premiums' do
        game.play_turn(data)
        expect(board.middle_square.premium).not_to be_active
      end

      it 'invalidates multipotents' do
        game.play_turn(data)
        expect(tiles.any? { |tile| tile.reload.multipotent? }).to eq(false)
      end

      it 'updates latest turn' do
        game.play_turn(data)

        expect(game.latest_turn.summary).to eq(I18n.t(
          'games.announcements.points_update',
          player: player_1.name,
          points: player_1.points
        ))
      end

      context 'game over' do
        before do
          game.tile_bag.tiles.each(&:destroy)
          game.reload
        end

        context 'player with empty rack' do
          before do
            player_1
              .tile_rack
              .tiles
              .last(TileRack::MAXIMUM_TILES - 3)
              .each(&:destroy)
            game.reload
          end

          it 'sets finished to true' do
            game.play_turn(data)
            expect(game.finished).to eq(true)
          end

          it 'updates scores' do
            game.play_turn(data)
            expect(player_1.points).to eq(tiles.map(&:points).sum * 2)
            expect(player_2.points).to eq(- player_2.tiles.map(&:points).sum)
          end
        end
      end
    end

    context 'invalid word' do
      let(:squares) do
        3.times.map { |y| board.square(y, y) }
      end

      it 'does not assign tiles to squares' do
        game.play_turn(data)

        expect(
          tiles.all? { |tile| tile.reload.tileable.is_a?(TileRack) }
        ).to eq(true)
      end

      it 'does not assign points to current player' do
        game.play_turn(data)
        expect(player_1.points).to eq(0)
      end

      it 'does not toggle current player' do
        game.play_turn(data)
        expect(game.current_player).to eq player_1
      end

      it 'does not invalidate premiums' do
        game.play_turn(data)
        expect(board.square(0, 0).premium).to be_active
      end

      it 'does not invalidate multipotents' do
        game.play_turn(data)
        expect(tiles.any? { |tile| tile.reload.multipotent? }).to eq(true)
      end

      it 'sets status message' do
        game.play_turn(data)

        expect(game.error_message).to eq(I18n.t(
          'games.error_messages.invalid_word'
        ))
      end
    end
  end

  describe '#skip_turn' do
    it 'toggles current player' do
      game.skip_turn
      expect(game.current_player).to eq(game.player_2)
    end

    it 'assigns new tiles' do
      tiles = player_1.tile_rack.tiles
      game.skip_turn(tiles.map(&:id))
      expect(player_1.reload.tile_rack.tiles).not_to eq(tiles)
    end

    it 'updates latest turn' do
      game.skip_turn

      expect(game.latest_turn.summary).to eq(I18n.t(
        'games.announcements.skipped_turn',
        player: player_1.name,
      ))
    end

    context 'game over' do
      before do
        game.tile_bag.tiles.each(&:destroy)
        game.reload
      end

      context 'both players pass' do
        let!(:turn_1) {
          create(
            :turn,
            points: 0,
            player: player_1,
            game: game
          )
        }

        it 'sets finished to true' do
          game.skip_turn
          expect(game.finished).to eq(true)
        end

        it 'updates player scores' do
          game.skip_turn
          expect(player_1.points).to eq(- player_1.tiles.map(&:points).sum)
          expect(player_2.points).to eq(- player_2.tiles.map(&:points).sum)
        end
      end
    end
  end
end
