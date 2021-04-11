import { Controller } from 'stimulus'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['invitations', 'invitee', 'games']

  connect() {
    this.channel = consumer.subscriptions.create('InvitationChannel', {
      received: this.cableReceived.bind(this),
    })
  }

  cableReceived(data) {
    const invitations = data.invitations && data.invitations[this.userId()]
    const games = data.games && data.games[this.userId()]

    if (!!invitations) {
      this.invitationsTarget.innerHTML = invitations
      this.setAuthenticityToken()
    }

    if (!!games) {
      this.gamesTarget.innerHTML = games
    }
  }

  create(event) {
    event.preventDefault()

    fetch(
      `${this.baseUrl()}/invitations?invitee_id=${this.inviteeId()}`,
      {
        method: 'POST',
        headers: {
          'X-CSRF-Token': this.csrfToken()
        }
      }
    )
  }

  setAuthenticityToken() {
    if (!!this.authenticityTokenInput()) {
      this.authenticityTokenInput().value = this.csrfToken()
    }
  }

  authenticityTokenInput() {
    return this.invitationsTarget.querySelector('input[name="authenticity_token"]')
  }

  userId() {
    return this.element.getAttribute('data-user')
  }

  inviteeId() {
    return this.inviteeTarget.value
  }

  csrfToken() {
    return document.getElementsByName('csrf-token').length &&
      document.getElementsByName('csrf-token')[0].content
  }

  baseUrl() {
    return window.location.origin
  }
}
