import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['space']

  dragStart(event) {
    event.dataTransfer.setData('tile', event.target.id)
    event.target.style.opacity = 0.1
  }

  dragEnd(event) {
    event.target.style.opacity = 1
  }

  drop(event) {
    event.preventDefault()
    const data = event.dataTransfer.getData('tile')
    const tile = document.getElementById(data)
    const target = event.currentTarget
    const targetChild = target.lastElementChild

    if (!targetChild || !targetChild.classList.value.includes('tile')) {
      target.appendChild(tile)
    } else if (this.isTileRack(target) && targetChild !== tile) {
      this.insertTile(tile, target, targetChild)
    }
  }

  insertTile(tile, target, targetChild) {
    const direction = this.direction(tile, target)

    while (!!tile) {
      target.appendChild(tile)
      tile = targetChild
      target = this.nextSpace(target, direction)

      if (!!target) {
        targetChild = target.lastElementChild
      }
    }
  }

  isTileRack(target) {
    return target.parentElement.classList.value.includes('tile-rack')
  }

  direction(tile, target) {
    return this.emptySpacesOnRight(tile, target).length > 0 ? 1 : -1
  }


  emptySpacesOnRight(tile, target) {
    return this.emptySpaces(tile).filter((space) => {
      return this.spaceNumber(space) - this.spaceNumber(target) > 0
    })
  }

  emptySpaces(tile) {
    return this.spaceTargets.filter((space) => {
      return !space.lastElementChild || space.lastElementChild === tile
    })
  }

  nextSpace(space, direction) {
    return this.space(this.spaceNumber(space) + direction)
  }

  spaceNumber(space) {
    return parseInt(space.id.split('_')[1])
  }

  space(num) {
    return this.spaceTargets.find((space) => space.id == `space_${num}`)
  }

  dragOver(event) {
    event.preventDefault()
  }
}
