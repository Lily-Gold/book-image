import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay"]

  connect() {
    this._onForceClose = () => {
      if (this.panelTarget.classList.contains("-translate-y-full")) return
      this.close()
    }
    window.addEventListener("mobile-search:close", this._onForceClose)
  }

  disconnect() {
    window.removeEventListener("mobile-search:close", this._onForceClose)
  }

  toggle() {
    if (this.panelTarget.classList.contains("-translate-y-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    // ✅ 先にメニューを閉じる（アニメも走る）
    window.dispatchEvent(new CustomEvent("mobile-menu:close"))

    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.add("opacity-100")

    this.panelTarget.classList.remove("-translate-y-full")
  }

  close() {
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.remove("opacity-100")

    this.panelTarget.classList.add("-translate-y-full")
  }
}
