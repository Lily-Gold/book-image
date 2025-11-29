import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "spinner", "label"]
  static values = { loadingText: String }

  submit() {
    // ボタン無効化
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.classList.add("opacity-70", "cursor-not-allowed")
    }

    // テキストを「投稿中… / 更新中…」に変更
    if (this.hasLabelTarget && this.hasLoadingTextValue) {
      this.labelTarget.textContent = this.loadingTextValue
    }

    // スピナー
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("hidden")
    }
  }
}
