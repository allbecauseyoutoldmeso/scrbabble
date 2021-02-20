require 'rails_helper'

describe 'user creates game' do
  let!(:user_1) { create(:user, name: 'user_1', password: 'password') }
  let!(:user_2) { create(:user, name: 'user_2', password: 'password') }

  before do
    log_in(user_1)
  end

  scenario 'user creates game successfully' do
    visit(root_path)
    click_link('new game')
    select(user_2.name, from: 'rival')
    click_button('Create Game')
    game = Game.last
    expect(current_path).to eq(game_path(game))
  end
end
