require 'spec_helper'

describe 'GamePresenter' do
  let(:game) { create(:game) }
  let(:game_presenter) { GamePresenter.new(game) }

  it 'returns board as json object' do
    expected_output = Board::BOARD_SIZE.times.map do |x|
      Board::BOARD_SIZE.times.map do |y|
        { x: x, y: y}
      end
    end.flatten

    expect(game_presenter.board).to eq(expected_output)
  end
end
