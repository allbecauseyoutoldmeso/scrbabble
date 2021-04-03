require 'rails_helper'
include ActiveJob::TestHelper

describe 'Turn' do
  describe '#create' do
    let(:user) {
      create(
        :user,
        email_address: 'scrbabble.genius@example.com',
        email_updates: true
      )
    }

    let(:player_1) { create(:player, user: user) }
    let(:player_2) { create(:player) }
    let(:game) { create(:game, players: [player_1, player_2]) }
    let(:turn) { build(:turn, game: game, player: player_2, points: 10) }

    it 'sends update to other player' do
      perform_enqueued_jobs queue: :default do
        turn.save
        expect(ActionMailer::Base.deliveries.last.subject).to eq(turn.summary)
      end
    end
  end
end
