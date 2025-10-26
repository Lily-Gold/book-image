import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.isVisible = false
  }

  show() {
    const menu = this.menuTarget
    menu.classList.remove("hidden", "opacity-0", "scale-95")
    menu.classList.add("opacity-100", "scale-100")
    this.isVisible = true
  }

  hide() {
    const menu = this.menuTarget
    menu.classList.remove("opacity-100", "scale-100")
    menu.classList.add("opacity-0", "scale-95")
    setTimeout(() => {
      menu.classList.add("hidden")
    }, 150)
    this.isVisible = false
  }

  toggle() {
    this.isVisible ? this.hide() : this.show()
  }
}
