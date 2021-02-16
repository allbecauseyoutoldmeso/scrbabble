require 'rails_helper'

describe 'WordSmith' do
  let!(:game) { create(:game) }
  let(:board) { game.board }
  let(:tile_bag) { game.tile_bag }
  let(:tiles) { tile_bag.tiles.first(3) }

  let(:squares) do
    3.times.map { |y| board.square(0, y) }
  end

  let(:data) do
    tiles.zip(squares).map do |array|
      { tile_id: array[0].id, square_id: array[1].id }
    end
  end

  let(:word_smith) { WordSmith.new(data: data, board: board) }

  describe '#valid?' do
    context 'tiles are continuous and on single axis' do
      it 'returns true' do
        word_smith.assign_tiles
        expect(word_smith.valid?).to eq true
      end
    end

    context 'tiles are not continuous' do
      let(:squares) do
        3.times.map { |y| board.square(0, y * y) }
      end

      it 'returns false' do
        expect(word_smith.valid?).to eq false
      end
    end

    context 'tiles are not on single axis' do
      let(:squares) do
        3.times.map { |y,| board.square(y, y) }
      end

      it 'returns false' do
        expect(word_smith.valid?).to eq false
      end
    end

    context 'new words do not use old tiles' do
      let(:old_tile) { tile_bag.tiles.last }

      before do
        board.square(10, 10).update(tile: old_tile)
      end

      it 'returns false' do
        word_smith.assign_tiles
        expect(word_smith.valid?).to eq false
      end
    end
  end

  describe '#assign_tiles' do
    it 'assigns tiles to squares' do
      word_smith.assign_tiles
      expect(tiles.all? { |tile|
        tile.reload.tileable.is_a?(Square)
      }).to eq(true)
    end
  end

  describe '#points' do
    it 'returns sum of points for all tiles' do
      word_smith.assign_tiles
      expect(word_smith.points).to eq(tiles.map(&:points).sum)
    end

    context 'word includes tiles already on board' do
      context 'down word' do
        let(:extra_tile) { tile_bag.tiles.where(points: 1..).last }
        let(:all_tiles) { tiles.push(extra_tile) }

        before do
          board.square(0, 3).update(tile: extra_tile)
        end

        it 'returns sum of points for all tiles in word' do
          word_smith.assign_tiles
          expect(word_smith.points).to eq(all_tiles.map(&:points).sum)
        end
      end

      context 'accross word' do
        let(:squares) do
          3.times.map { |x| board.square(x, 0) }
        end

        let(:extra_tile) { tile_bag.tiles.where(points: 1..).last }
        let(:all_tiles) { tiles.push(extra_tile) }

        before do
          board.square(3, 0).update(tile: extra_tile)
        end

        it 'returns sum of points for all tiles in word' do
          word_smith.assign_tiles
          expect(word_smith.points).to eq(all_tiles.map(&:points).sum)
        end
      end
    end

    context 'more than one word created' do
      let(:old_tile_1) { tile_bag.tiles.where(points: 1..)[0] }
      let(:old_tile_2) { tile_bag.tiles.where(points: 1..)[1] }
      let(:new_tile) { tile_bag.tiles.where(points: 1..)[2] }

      let(:data) {
        [
          {
            tile_id: new_tile.id,
            square_id: board.square(1, 1).id
          }
        ]
      }

      before do
        board.square(0, 1).update(tile: old_tile_1)
        board.square(1, 0).update(tile: old_tile_2)
      end

      it 'returns sum of points for all words' do
        word_smith.assign_tiles
        expect(word_smith.points).to eq(
          old_tile_1.points + old_tile_2.points + (new_tile.points * 2)
        )
      end
    end
  end
end
