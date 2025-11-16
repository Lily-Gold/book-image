import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-tag"
export default class extends Controller {
  static targets = ["select", "preview"]

  connect() {
    this.updatePreview()
  }

  updatePreview() {
    const selectedOption = this.selectTarget.selectedOptions[0]
    if (!selectedOption) return

    const color = selectedOption.dataset.color
    this.previewTarget.style.backgroundColor = color || "#ccc"
  }
}
