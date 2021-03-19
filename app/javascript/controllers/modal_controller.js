import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['modal', 'skip']

  showSkipModal() {
    this.showModal()
    this.skipTarget.classList.remove('hidden')
  }

  showModal() {
    this.modalTarget.classList.remove('hidden')
  }

  hideModal() {
    this.modalTarget.classList.add('hidden')
  }
}
