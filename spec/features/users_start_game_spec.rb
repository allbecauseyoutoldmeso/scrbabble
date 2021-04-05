require 'rails_helper'

describe 'users start game' do
  let!(:user_1) { create(:user, name: 'user_1', password: 'password') }
  let!(:user_2) { create(:user, name: 'user_2', password: 'password') }

  scenario 'users start game successfully', js: true do
    log_in(user_1)

    select(
      user_2.name,
      from: I18n.t('activerecord.attributes.invitation.invitee')
    )

    click_button(I18n.t('helpers.submit.invitation.create'))

    expect(page).to have_content(
      I18n.t(
        'games.index.invitation_sent',
        user: user_2.name
      )
    )

    click_button('log out')
    log_in(user_2)

    expect(page).to have_content(
      I18n.t(
        'games.index.invitation_received',
        user: user_1.name
      )
    )

    click_button(I18n.t('helpers.submit.game.create'))

    expect(page).to have_content(
      I18n.t(
        'games.show.players_turn',
        player: user_2.name
      )
    )
  end
end
