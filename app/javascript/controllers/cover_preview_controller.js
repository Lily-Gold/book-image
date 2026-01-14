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
    
    // 【ステップ1】API画像があれば表示(最優先)
    if (this.hasUrlFieldTarget && this.urlFieldTarget.value) {
      this.showExternal(this.urlFieldTarget.value)
    }
    
    // 【ステップ2】アップロード画像の表示判定
    this.clearUploadPreviewIfNeeded()
    
  }

  clearUploadPreviewIfNeeded() {
  
    // 【重要】既存レコードの場合は何もしない
    if (!this.isNewRecord()) {
      return
    }
  
    // 【重要】新規作成時で、API画像またはアップロード画像がある場合は何もしない
    if (this.hasApiCover() || this.hasAttachedCover()) {
      return
    }
  
    // 【重要】新規作成時で、画像がない場合はプレビューをクリア
    this.previewTarget.src = ""
    this.previewTarget.classList.add("hidden")
    this.removeButtonTarget.classList.add("hidden")
  
  }

  // 新規投稿かどうか
  isNewRecord() {
    // data-cover-attached が 'true' 以外の場合は新規作成
    return this.element.dataset.coverAttached !== 'true'
  }

  // API画像があるか
  hasApiCover() {
    return this.hasUrlFieldTarget && this.urlFieldTarget.value !== ''
  }

  // 既に添付されている画像があるか
  hasAttachedCover() {
    return this.element.dataset.coverAttached === 'true'
  }

  show(event) {
    const file = event.target.files[0]
    if (!file) return

    if (this.hasUrlFieldTarget) {
      this.urlFieldTarget.value = ""
    }

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

    if (this.hasUrlFieldTarget) {
      this.urlFieldTarget.value = url
    }

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

    if (this.hasUrlFieldTarget) {
      this.urlFieldTarget.value = ""
    }

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
