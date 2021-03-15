require 'rails_helper'

describe 'creating account' do
  scenario 'user successfully creates account' do
    visit(root_path)
    click_link(I18n.t('sessions.new.create_new_user'))
    fill_in(I18n.t('activerecord.attributes.user.name'), with: 'user_1')
    fill_in(I18n.t('activerecord.attributes.user.password'), with: 'password')
    click_button(I18n.t('helpers.submit.user.create'))
    expect(page).to have_text(I18n.t('games.index.new_game'))
  end
end
