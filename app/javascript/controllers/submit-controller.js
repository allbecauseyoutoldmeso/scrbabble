import { Controller } from 'stimulus'
import Rails from '@rails/ujs'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['square', 'shared', 'rack']

  connect() {
    this.channel = consumer.subscriptions.create('GameChannel', {
      received: this.cableReceived.bind(this),
    })
  }

  cableReceived(data) {
    this.sharedTarget.innerHTML = data.shared
  }

  async onClick(event) {
    await this.playTurn()
    this.refillTileRack()
  }

  async playTurn() {
    await fetch(
      `${this.gameId()}?data=${JSON.stringify(this.requestData())}`,
      {
        method: 'PUT',
        headers: {
          'X-CSRF-Token': this.csrfToken()
        }
      }
    )
  }

  refillTileRack() {
    // can I use fetch instead?
    const tileRack = this.rackTarget

    Rails.ajax({
      type: 'GET',
      url: `${this.gameId()}/tile_rack`,
      success: (_data, _status, xhr) => {
        tileRack.innerHTML = xhr.response
      }
    })
  }

  csrfToken() {
    return document.getElementsByName('csrf-token')[0].content
  }

  gameId() {
    return this.element.getAttribute('data-game')
  }

  requestData() {
    return this.squaresWithTiles().map((square) => this.squareData(square))
  }

  squareData(square) {
    return {
      square_id: square.id.split('_')[1],
      tile_id: square.firstElementChild.id.split('_')[1]
    }
  }

  squaresWithTiles() {
    return this.squareTargets.filter(
      (square) => {
        return square.children[0] && square.children[0].className == 'tile'
      }
    )
  }
}
