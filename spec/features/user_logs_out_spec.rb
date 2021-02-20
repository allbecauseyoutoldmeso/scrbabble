require 'rails_helper'

describe 'log out' do
  let(:user) { create(:user, name: 'name', password: 'password') }

  scenario 'user logs out successfully' do
    log_in(user)
    click_button('log out')
    expect(current_path).to eq(new_session_path)
  end
end
