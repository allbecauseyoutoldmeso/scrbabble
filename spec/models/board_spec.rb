require 'spec_helper'

describe 'Board' do
  describe '#create' do
    let(:game) { create(:game) }
    let(:board) { create(:board, game: game) }

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
end
