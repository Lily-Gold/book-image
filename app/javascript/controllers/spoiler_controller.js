import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    if (window.innerWidth >= 768) return

    this.contentTarget.classList.toggle("opacity-10")
  }
}
