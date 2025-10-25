import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    // フェードイン
    this.element.classList.remove("opacity-0", "translate-y-[-10px]")
    this.element.classList.add("opacity-100", "translate-y-0")

    // 指定時間後に自動で閉じる（デフォルト3秒）
    setTimeout(() => {
      this.close()
    }, this.timeoutValue || 3000)
  }

  close() {
    // フェードアウト
    this.element.classList.add("opacity-0", "translate-y-[-10px]")
    setTimeout(() => this.element.remove(), 300)
  }
}
