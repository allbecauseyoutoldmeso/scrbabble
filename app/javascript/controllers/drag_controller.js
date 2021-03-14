import { Controller } from 'stimulus'

export default class extends Controller {
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
    const targetChild = event.currentTarget.lastElementChild

    if (!targetChild || !targetChild.classList.value.includes('tile')) {
      event.currentTarget.appendChild(document.getElementById(data))
    }
  }

  dragOver(event) {
    event.preventDefault()
  }
}
