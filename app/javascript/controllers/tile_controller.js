import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['letter', 'form']

  onClick(event) {
    event.preventDefault()
    const tileId = this.element.id
    const letter = this.letterTarget.value

    //can I just use fetch + render_as_string?
    Rails.ajax({
      type: 'PUT',
      url: `${this.baseUrl()}/tiles/${this.tileId()}?letter=${this.letter()}`,
      success: (data, status, xhr) => {
        this.element.outerHTML = xhr.response
      }
    })
  }

  onDoubleClick(event) {
    if (this.isMultipotent()) {
      this.formTarget.classList.toggle('hidden')
    }
  }

  isMultipotent() {
    return this.element.classList.value.includes('multipotent')
  }

  baseUrl() {
    return window.location.origin
  }

  tileId() {
    return this.element.id.split('_')[1]
  }

  letter() {
    return this.letterTarget.value
  }
}
