import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    const menu = this.menuTarget
    const isHidden = menu.classList.contains("hidden")

    if (isHidden) {
      menu.classList.remove("hidden")
      setTimeout(() => {
        menu.classList.remove("opacity-0", "scale-95")
        menu.classList.add("opacity-100", "scale-100")
      }, 10)
    } else {
      menu.classList.add("opacity-0", "scale-95")
      setTimeout(() => menu.classList.add("hidden"), 200)
    }
  }

  connect() {
    document.addEventListener("click", this.closeOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOutside)
  }

  closeOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
