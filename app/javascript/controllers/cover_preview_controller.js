import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "removeButton", "removeField"]

  show(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = e => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("hidden")
      this.removeButtonTarget.classList.remove("hidden")

      this.removeFieldTarget.value = "0"
    }
    reader.readAsDataURL(file)
  }

  remove() {
    this.inputTarget.value = ""

    this.previewTarget.src = ""
    this.previewTarget.classList.add("hidden")

    this.removeButtonTarget.classList.add("hidden")

    this.removeFieldTarget.value = "1"
  }
}
