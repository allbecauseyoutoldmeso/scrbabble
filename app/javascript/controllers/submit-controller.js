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

  onClick(event) {
    this.playTurn()
    this.refillTileRack()
  }

  playTurn() {
    Rails.ajax({
      type: 'PUT',
      url: `${this.gameId()}?data=${JSON.stringify(this.requestData())}`
    })
  }

  refillTileRack() {
    const tileRack = this.rackTarget

    Rails.ajax({
      type: 'GET',
      url: `${this.gameId()}/tile_rack`,
      success: (_data, _status, xhr) => {
        tileRack.innerHTML = xhr.response
      }
    })
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
