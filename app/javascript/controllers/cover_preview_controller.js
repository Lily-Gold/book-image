import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "preview",
    "removeButton",
    "removeField",
    "removeUrlField",
    "urlField"
  ]

  connect() {
    // 編集画面用：保存済みの API 画像を表示
    if (this.hasUrlFieldTarget && this.urlFieldTarget.value) {
      this.showExternal(this.urlFieldTarget.value)
    }
  }

  show(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = e => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("hidden")
      this.removeButtonTarget.classList.remove("hidden")

      // アップロード画像を使う＝削除しない
      if (this.hasRemoveFieldTarget) {
        this.removeFieldTarget.value = "0"
      }

      // API画像は使わない
      if (this.hasRemoveUrlFieldTarget) {
        this.removeUrlFieldTarget.value = "1"
      }
    }
    reader.readAsDataURL(file)
  }

  showExternal(url) {
    if (!url) return

    this.previewTarget.src = url
    this.previewTarget.classList.remove("hidden")
    this.removeButtonTarget.classList.remove("hidden")

    this.inputTarget.value = ""

    // API画像を使う＝削除しない
    if (this.hasRemoveUrlFieldTarget) {
      this.removeUrlFieldTarget.value = "0"
    }

    // アップロード画像は使わない
    if (this.hasRemoveFieldTarget) {
      this.removeFieldTarget.value = "1"
    }
  }

  remove() {
    this.inputTarget.value = ""

    this.previewTarget.src = ""
    this.previewTarget.classList.add("hidden")
    this.removeButtonTarget.classList.add("hidden")

    // 両方「消す」
    if (this.hasRemoveFieldTarget) {
      this.removeFieldTarget.value = "1"
    }

    if (this.hasRemoveUrlFieldTarget) {
      this.removeUrlFieldTarget.value = "1"
    }
  }
}
