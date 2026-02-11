import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay"]

  toggle() {
    if (this.panelTarget.classList.contains("translate-x-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    // メニュー表示
    this.panelTarget.classList.remove("translate-x-full")

    // 背景表示
    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.add("opacity-100")
  }

  close() {
    // メニュー非表示
    this.panelTarget.classList.add("translate-x-full")

    // 背景非表示
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.remove("opacity-100")
  }
}
