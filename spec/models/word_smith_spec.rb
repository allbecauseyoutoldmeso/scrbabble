require 'rails_helper'

describe 'WordSmith' do
  let!(:game) { create(:game) }
  let(:board) { game.board }
  let(:tile_bag) { game.tile_bag }
  let(:tiles) { tile_bag.tiles.first(3) }

  let(:squares) do
    3.times.map do |y|
      board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + y)
    end
  end

  let(:data) do
    tiles.zip(squares).map do |array|
      { tile_id: array[0].id, square_id: array[1].id }
    end
  end

  let(:word_smith) { WordSmith.new(data: data, board: board) }

  before do
    stub_request(:get, %r{http://api.wordnik.com})
      .to_return(body: { value: 9 }.to_json)
  end

  describe '#assign_tiles' do
    it 'assigns tiles to squares' do
      word_smith.assign_tiles

      expect(tiles.all? { |tile|
        tile.reload.tileable.is_a?(Square)
      }).to eq(true)
    end

    context 'tiles are not continuous' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + y**2)
        end
      end

      it 'raises error' do
        expect {
          word_smith.assign_tiles
        }.to raise_error(WordSmith::InvalidWord)

        expect(tiles.any? { |tile|
          tile.reload.tileable.is_a?(Square)
        }).to eq(false)
      end
    end

    context 'tiles cross previous word' do
      let(:squares) do
        [
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 - 1),
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 1),
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 2)
        ]
      end

      let(:old_tile) { tile_bag.tiles.last }

      before do
        board.middle_square.update(tile: old_tile)
      end

      it 'assigns tiles to squares' do
        word_smith.assign_tiles

        expect(tiles.all? { |tile|
          tile.reload.tileable.is_a?(Square)
        }).to eq(true)
      end
    end

    context 'tiles are not on single axis' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2 + y, Board::BOARD_SIZE/2 + y)
        end
      end

      it 'raises error' do
        expect {
          word_smith.assign_tiles
        }.to raise_error(WordSmith::InvalidWord)

        expect(tiles.any? { |tile|
          tile.reload.tileable.is_a?(Square)
        }).to eq(false)
      end
    end

    context 'new words do not use old tiles' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2 + 2, Board::BOARD_SIZE/2 + y)
        end
      end

      let(:old_tile) { tile_bag.tiles.last }

      before do
        board.middle_square.update(tile: old_tile)
      end


      it 'raises error' do
        expect {
          word_smith.assign_tiles
        }.to raise_error(WordSmith::InvalidWord)

        expect(tiles.any? { |tile|
          tile.reload.tileable.is_a?(Square)
        }).to eq(false)
      end
    end

    context 'invalid word' do
      before do
        stub_request(:get, %r{http://api.wordnik.com})
          .to_return(body: { error_message: 'not found' }.to_json)
      end

      it 'raises error' do
        expect {
          word_smith.assign_tiles
        }.to raise_error(WordSmith::InvalidWord)

        expect(tiles.any? { |tile|
          tile.reload.tileable.is_a?(Square)
        }).to eq(false)
      end
    end
  end

  describe '#points' do
    context 'word includes tiles already on board' do
      let(:squares) do
        [
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 - 1),
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 1),
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 2)
        ]
      end

      let(:old_tile) { tile_bag.tiles.where(points: 1..).last }
      let(:all_tiles) { tiles.push(old_tile) }

      before do
        board.middle_square.update(tile: old_tile)
        board.middle_square.premium.update(active: false)
        word_smith.assign_tiles
      end

      it 'returns sum of points for all tiles in word' do
        expect(word_smith.points).to eq(all_tiles.map(&:points).sum)
      end
    end

    context 'more than one word created' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2 + 1, Board::BOARD_SIZE/2 + y + 2)
        end
      end

      let(:old_tiles) { tile_bag.tiles.where(points: 1..).last(3) }

      let(:old_squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + y)
        end
      end

      before do
        old_squares.zip(old_tiles).each do |array|
          array[0].update(tile: array[1])
        end

        word_smith.assign_tiles
      end


      it 'returns sum of points for all words' do
        expect(word_smith.points).to eq(
          old_tiles[2].points +
          tiles[0].points * 2 +
          tiles[1].points +
          tiles[2].points
        )
      end
    end

    context 'double word score' do
      it 'returns double sum of points for all tiles' do
        word_smith.assign_tiles
        expect(word_smith.points).to eq(tiles.map(&:points).sum * 2)
      end
    end

    context 'double letter score' do
      let(:squares) do
        3.times.map do |y|
          board.square(Board::BOARD_SIZE/2 + 1, Board::BOARD_SIZE/2 + y)
        end
      end

      let(:old_tile) { tile_bag.tiles.where(points: 1..).last }
      let(:all_tiles) { tiles.push(old_tile) }

      before do
        board.middle_square.update(tile: old_tile)
        board.middle_square.premium.update(active: false)
        word_smith.assign_tiles
      end

      it 'returns double sum of points for all tiles' do
        expect(word_smith.points).to eq(
          old_tile.points +
          tiles[0].points * 2 +
          tiles[1].points +
          tiles[2].points * 2
        )
      end
    end

    context 'inactive premium' do
      before do
        board.middle_square.premium.inactivate
        word_smith.assign_tiles
      end

      it 'returns only the sum of points for the tiles' do
        expect(word_smith.points).to eq(tiles.map(&:points).sum)
      end
    end

    context 'all tiles in tile rack used' do
      let(:tiles) { tile_bag.tiles.first(TileRack::MAXIMUM_TILES) }

      let(:squares) {
        TileRack::MAXIMUM_TILES.times.map do |y|
          board.square(Board::BOARD_SIZE/2 + 1, Board::BOARD_SIZE/2 + y)
        end
      }

      let(:old_tile) { tile_bag.tiles.where(points: 1..).last }

      before do
        board.middle_square.update(tile: old_tile)
        board.middle_square.premium.update(active: false)
        word_smith.assign_tiles
      end

      it 'adds bonus to score if all tiles used' do
        expect(word_smith.points).to eq(
          old_tile.points +
          tiles.map(&:points).sum +
          tiles[0].points +
          tiles[1].points +
          tiles[5].points +
          Game::BONUS
        )
      end
    end
  end

  describe '#inactivate_premiums' do
    it 'sets active to false on premiums' do
      word_smith.assign_tiles
      word_smith.inactivate_premiums
      expect(board.middle_square.premium).not_to be_active
    end
  end
end
