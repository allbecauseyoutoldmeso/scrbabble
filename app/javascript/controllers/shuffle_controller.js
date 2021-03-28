import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['space']

  shuffleTiles() {
    this.shuffledTiles().forEach((tile, index) => {
      this.spaceTargets[index].appendChild(tile)
    })
  }

  shuffledTiles() {
    return this.tiles().sort(() => .5 - Math.random())
  }

  tiles() {
    return this.spaceTargets.map((space) => {
      return space.lastElementChild
    }).filter((tile) => {
      return !!tile
    })
  }
}
