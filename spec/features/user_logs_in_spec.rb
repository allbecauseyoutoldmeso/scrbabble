require 'rails_helper'

describe 'log in' do
  let(:user) { create(:user, name: 'name', password: 'password') }

  scenario 'user logs in successfully' do
    visit(root_path)
    fill_in('name', with: user.name)
    fill_in('password', with: user.password)
    click_button('log in')
    expect(page).to have_link('new game')
  end
end
