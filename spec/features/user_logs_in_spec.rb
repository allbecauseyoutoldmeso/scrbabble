require 'rails_helper'

describe 'log in' do
  let(:user) { create(:user, name: 'name', password: 'password') }

  scenario 'user logs in successfully' do
    visit(root_path)
    fill_in(I18n.t('activerecord.attributes.user.name'), with: user.name)
    fill_in(
      I18n.t('activerecord.attributes.user.password'),
      with: user.password
    )
    click_button(I18n.t('sessions.create'))
    expect(page).to have_link(I18n.t('games.index.new_game'))
  end
end
