require 'rails_helper'

describe 'Square' do
  describe '#letter_tuple' do
    let(:game) { create(:game) }

    let(:square) {
      game.board.squares.find { |square| square.premium.nil? }
    }

    context 'letter premium' do
      let!(:premium) {
        create(:premium, tuple: 2, target: :letter, square: square)
      }

      it 'returns tuple' do
        expect(square.letter_tuple).to eq(premium.tuple)
      end
    end

    context 'no word premium' do
      it 'returns 1' do
        expect(square.letter_tuple).to eq(1)
      end
    end
  end

  describe '#word_tuple' do
    let(:game) { create(:game) }

    let(:square) {
      game.board.squares.find { |square| square.premium.nil? }
    }

    context 'word premium' do
      let!(:premium) {
        create(:premium, tuple: 2, target: :word, square: square)
      }


      it 'returns tuple' do
        expect(square.word_tuple).to eq(premium.tuple)
      end
    end

    context 'no word premium' do
      it 'returns 1' do
        expect(square.word_tuple).to eq(1)
      end
    end
  end
end
