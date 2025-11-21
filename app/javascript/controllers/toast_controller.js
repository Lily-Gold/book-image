import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    // ▼ フェードイン
    this.element.classList.remove("opacity-0", "translate-y-[-10px]")
    this.element.classList.add("opacity-100", "translate-y-0")

    // ▼ timeoutValue が 0 の場合は自動で閉じない
    if (this.timeoutValue > 0) {
      setTimeout(() => this.close(), this.timeoutValue)
    }
  }

  close() {
    // ▼ フェードアウト
    this.element.classList.add("opacity-0", "translate-y-[-10px]")

    // 完全に消す
    setTimeout(() => this.element.remove(), 300)
  }
}
