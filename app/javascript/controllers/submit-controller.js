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
    if (data.shared) {
      this.sharedTarget.innerHTML = data.shared
    } else if (data.tile_rack && data.player_id == this.playerId()) {
      this.rackTarget.innerHTML = data.tile_rack
    }
  }

  async onClick(event) {
    await this.playTurn()
    await this.updateShared()
    await this.updateTileRacks()
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

  async updateShared() {
    await fetch(`${this.gameId()}/update_shared`)
  }

  async updateTileRacks() {
    await fetch(`${this.gameId()}/update_tile_rack?player=1`)
    await fetch(`${this.gameId()}/update_tile_rack?player=2`)
  }

  csrfToken() {
    return document.getElementsByName('csrf-token')[0].content
  }

  playerId() {
    return this.element.getAttribute('data-player')
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
