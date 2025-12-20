import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "removeButton", "removeField"]

  previewImage(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("scale-195")

      this.previewTarget.classList.add("border", "border-gray-300")

      this.removeFieldTarget.value = "0"
      this.removeButtonTarget.classList.remove("hidden")
    }
    reader.readAsDataURL(file)
  }

  remove() {
    // input をリセット
    this.inputTarget.value = ""

    // ★ 見た目を「初期状態」に戻す
    this.previewTarget.src = this.previewTarget.dataset.defaultSrc
    this.previewTarget.classList.add("scale-195")

    this.previewTarget.classList.remove("border", "border-gray-300")
    
    // ★ × を消す
    this.removeButtonTarget.classList.add("hidden")

    // ★ サーバーに「削除した」ことを伝える
    this.removeFieldTarget.value = "1"
  }
}
