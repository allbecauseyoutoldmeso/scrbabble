import { Controller } from 'stimulus'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['invitee', 'games']

  connect() {
    this.channel = consumer.subscriptions.create('InvitationChannel', {
      received: this.cableReceived.bind(this),
    })
  }

  cableReceived(data) {
    this.gamesTarget.innerHTML = data.games[this.userId()]
    this.setAuthenticityTokens()
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

  setAuthenticityTokens() {
    this.authenticityTokenInputs().forEach((input) => {
      input.value = this.csrfToken()
    })
  }

  authenticityTokenInputs() {
    return this.element.querySelectorAll('input[name="authenticity_token"]')
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
