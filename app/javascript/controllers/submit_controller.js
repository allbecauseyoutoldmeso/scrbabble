import { Controller } from 'stimulus'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['square', 'shared', 'confidential', 'tile']

  connect() {
    this.channel = consumer.subscriptions.create('GameChannel', {
      received: this.cableReceived.bind(this),
    })
  }

  cableReceived(data) {
    this.sharedTarget.innerHTML = data.shared
    this.confidentialTarget.innerHTML = data.confidential[this.playerId()]
  }

  async skipTurn() {
    event.currentTarget.setAttribute('disabled', true)

    const params = {
      skip_turn: true,
      tile_ids: JSON.stringify(this.selectedTileIds())
    }

    this.updateGame(params)
  }

  selectedTileIds() {
    return this.selectedTiles().map((tile) => {
      return parseInt(tile.id.split('_')[2])
    })
  }

  selectedTiles() {
    return this.tileTargets.filter((tile) => {
      return tile.classList.value.includes('selected')
    })
  }

  async playTurn() {
    event.currentTarget.setAttribute('disabled', true)

    const params = {
      data: JSON.stringify(this.requestData())
    }

    this.updateGame(params)
  }

  async updateGame(params) {
    const query_string = new URLSearchParams(params).toString()

    await fetch(
      `${this.gameId()}?${query_string}`,
      {
        method: 'PUT',
        headers: {
          'X-CSRF-Token': this.csrfToken()
        }
      }
    )
  }

  selectTile(event) {
    event.currentTarget.classList.toggle('selected')
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
