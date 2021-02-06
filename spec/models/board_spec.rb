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
  end

  describe '#square' do
    it 'returns square with specified coordinates' do
      expect(
        board.square(5, 10).attributes.symbolize_keys.slice(:x, :y)
      ).to eq({ x: 5, y: 10 })
    end
  end
end
