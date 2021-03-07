import { Controller } from 'stimulus'
import Rails from '@rails/ujs'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['square', 'shared', 'rack', 'alert']

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
    } else if (data.alert && data.player_ids.includes(this.playerId())) {
      this.alertTarget.innerHTML = `
       <div class='alert'>
        ${data.alert}
       </div>
      `
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
    return document.getElementsByName('csrf-token').length &&
      document.getElementsByName('csrf-token')[0].content
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
      tile_id: square.children[1].id.split('_')[1]
    }
  }

  squaresWithTiles() {
    return this.squareTargets.filter(
      (square) => {
        return square.children[1] &&
        square.children[1].className.includes('tile')
      }
    )
  }
}
