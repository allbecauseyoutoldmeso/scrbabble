require 'rails_helper'

describe 'Board' do
  let(:game) { create(:game) }
  let(:board) { create(:board, game: game) }

  describe '#create' do
    it 'has squares' do
      expected_coordinates = Board::BOARD_SIZE.times.map do |x|
        Board::BOARD_SIZE.times.map do |y|
          { x: x, y: y}
        end
      end.flatten

      expect(board.squares.map { |square|
        square.attributes.symbolize_keys.slice(:x, :y)
      }).to eq(expected_coordinates)
    end

    it 'has_premiums' do
      premiums = board.squares.map(&:premium).compact

      premium_attributes = premiums.map do |premium|
        {
          target: premium.target.to_sym,
          tuple: premium.tuple,
          x: premium.square.x,
          y: premium.square.y
        }
      end

      expect(premium_attributes).to contain_exactly(*Board::PREMIUM_ATTRIBUTES)
    end
  end

  describe '#square' do
    it 'returns square with specified coordinates' do
      expect(
        board.square(5, 10).attributes.symbolize_keys.slice(:x, :y)
      ).to eq({ x: 5, y: 10 })
    end
  end

  describe '#tiles' do
    let!(:tile) { create(:tile, tileable: board.squares.first) }

    it 'returns tiles associated with squares' do
      expect(board.tiles).to eq([tile])
    end
  end
end
