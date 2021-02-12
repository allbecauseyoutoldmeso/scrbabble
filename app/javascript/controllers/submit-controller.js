import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['square', 'board']

  onClick(event) {
    const board = this.boardTarget

    Rails.ajax({
      type: 'PUT',
      url: `${this.gameId()}?data=${JSON.stringify(this.requestData())}`,
      success: (_data, _status, xhr) => {
        board.innerHTML = xhr.response
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
      (square) => !!square.children.length
    )
  }
}
