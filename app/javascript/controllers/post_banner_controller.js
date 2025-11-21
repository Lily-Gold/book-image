import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { visible: Boolean }

  connect() {
    if (this.visibleValue) {
      this.show()
    }
  }

  show() {
    this.element.classList.remove("hidden", "opacity-0", "translate-y-[-10px]")
    this.element.classList.add("opacity-100", "translate-y-0")
  }

  close() {
    this.element.classList.add("opacity-0", "translate-y-[-10px]")
    setTimeout(() => this.element.remove(), 300)
  }
}
