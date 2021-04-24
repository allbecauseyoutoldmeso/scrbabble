import { Controller } from 'stimulus'

export default class extends Controller {
  touchStart(event) {
    this.moving = event.currentTarget
    this.movingHeight = event.currentTarget.clientHeight
    this.movingWidth = event.currentTarget.clientWidth
    this.moving.style.position = 'fixed';
  }

  touchMove(event) {
    event.preventDefault()
    const changedTouch = event.changedTouches[0]
    this.moving.style.left = `${changedTouch.clientX - this.movingWidth/2}px`
    this.moving.style.top = `${changedTouch.clientY - this.movingHeight/2}px`
  }

  touchEnd(event) {
    this.moving.style.zIndex = -10
    const target = this.target(event)

    if (this.isValidTarget(target)) {
      target.appendChild(this.moving)
    }

    this.resetMoving()
  }

  resetMoving() {
    this.moving.style.zIndex = 1
    this.moving.style.left = ''
    this.moving.style.top = ''
  }

  target(event) {
    const changedTouch = event.changedTouches[0]

    const target = document.elementFromPoint(
      changedTouch.clientX,
      changedTouch.clientY
    )

    if (target.classList.value.includes('premium')) {
      return target.closest('.square')
    } else {
      return target
    }
  }

  isValidTarget(target) {
    return (this.isSquare(target) || this.isTileRack(target)) && this.isEmpty(target)
  }

  isSquare(target) {
    return target.classList.value.includes('square')
  }

  isTileRack(target) {
    return target.classList.value.includes('tile-rack-space')
  }

  isEmpty(target) {
    const targetChild = target.lastElementChild
    return !targetChild || !targetChild.classList.value.includes('tile')
  }
}
