import { Controller } from 'stimulus'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['invitations', 'invitee']

  connect() {
    this.channel = consumer.subscriptions.create('GameChannel', {
      received: this.cableReceived.bind(this),
    })
  }

  cableReceived(data) {
    const invitations = data.invitations[this.userId()]

    if (!!invitations) {
      this.invitationsTarget.innerHTML = data.invitations[this.userId()]
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
