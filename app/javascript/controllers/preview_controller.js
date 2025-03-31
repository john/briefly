import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  startLoading(event) {
    const loadingElement = document.querySelector('.preview-loading')
    if (loadingElement) {
      loadingElement.classList.remove('hidden')
    }
  }
} 