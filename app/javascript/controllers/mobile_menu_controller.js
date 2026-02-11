import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay", "line1", "line2", "line3", "icon"]

  connect() {
    // Turbo遷移直後のチラつき防止
    this.panelTarget.classList.add("translate-x-full")

    // オーバーレイも確実に閉じる
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.remove("opacity-100")

    // 三本線も強制リセット
    this.line1Target.classList.remove("rotate-45", "translate-y-[6px]")
    this.line2Target.classList.remove("opacity-0")
    this.line3Target.classList.remove("-rotate-45", "-translate-y-[6px]")

    this._onForceClose = () => {
      if (this.panelTarget.classList.contains("translate-x-full")) return
      this.close()
    }

    window.addEventListener("mobile-menu:close", this._onForceClose)
  }

  disconnect() {
    window.removeEventListener("mobile-menu:close", this._onForceClose)
  }

  toggle() {
    if (this.panelTarget.classList.contains("translate-x-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    window.dispatchEvent(new CustomEvent("mobile-search:close"))

    this.panelTarget.classList.remove("translate-x-full")

    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.add("opacity-100")

    this.line1Target.classList.add("rotate-45", "translate-y-[6px]")
    this.line2Target.classList.add("opacity-0")
    this.line3Target.classList.add("-rotate-45", "-translate-y-[6px]")
  }

  close() {
    this.panelTarget.classList.add("translate-x-full")

    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.remove("opacity-100")

    this.line1Target.classList.remove("rotate-45", "translate-y-[6px]")
    this.line2Target.classList.remove("opacity-0")
    this.line3Target.classList.remove("-rotate-45", "-translate-y-[6px]")
  }
}
