require 'spec_helper'

describe 'Game' do
  describe '#create' do
    let(:game) { create(:game) }

    it 'has board' do
      expect(game.board).to be_present
    end

    it 'has tile_bag' do
      expect(game.tile_bag).to be_present
    end

    it 'has players' do
      expect(game.players.count).to eq(2)
    end
  end
end
