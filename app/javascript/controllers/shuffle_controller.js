import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['space']

  shuffleTiles() {
    const tiles = this.tiles().sort(() => .5 - Math.random())

    this.spaceTargets.forEach((space, index) => {
      space.appendChild(tiles[index])
    })
  }

  tiles() {
    return this.spaceTargets.map((space) => space.lastElementChild)
  }
}
