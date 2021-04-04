require 'rails_helper'

describe 'editing preferences' do
  let(:user) {
    create(
      :user,
      name: 'snoopy',
      password: 'password',
      email_updates: false
    )
  }

  scenario 'user successfully edits preferences' do
    log_in(user)
    click_link(I18n.t('navbar.edit_user'))
    fill_in(I18n.t('activerecord.attributes.user.name'), with: 'woodstock')

    fill_in(
      I18n.t('activerecord.attributes.user.email_address'),
      with: 'woodstock@peanuts.com'
    )

    check(I18n.t('activerecord.attributes.user.email_updates'))
    click_button(I18n.t('helpers.submit.user.update'))

    expect(user.reload.name).to eq('woodstock')
  end
end
