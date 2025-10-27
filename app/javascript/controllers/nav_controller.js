import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.lastScroll = 0
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll)
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    const currentScroll = window.scrollY

    if (currentScroll > this.lastScroll && currentScroll > 50) {
      this.element.classList.add("-translate-y-full")
    }
    else if (currentScroll < this.lastScroll) {
      this.element.classList.remove("-translate-y-full")
    }

    this.lastScroll = currentScroll
  }
}
