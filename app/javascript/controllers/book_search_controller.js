import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    noCoverUrl: String
  }

  static targets = [
    "input",
    "results",
    "title",
    "author",
    "publisher",
    "isbn",
    "description",
    "publishedOn",
    "googleId",
    "coverUrl"
  ]
  
  connect() {
    console.log("BookSearch controller connected!")
    this.searchTimeout = null
  }
  
  search(event) {
    const query = event.target.value.trim()
    
    console.log("検索語:", query)
    
    if (query.length < 2) {
      this.hideResults()
      return
    }
    
    clearTimeout(this.searchTimeout)
    this.searchTimeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }
  
  async performSearch(query) {
    console.log("API呼び出し開始:", query)
    
    try {
      const response = await fetch(
        `/api/google_books/search?q=${encodeURIComponent(query)}`,
        {
          headers: {
            'Accept': 'application/json'
          }
        }
      )
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const books = await response.json()
      console.log("取得した本:", books)
      
      this.displayResults(books)
    } catch (error) {
      console.error('Search error:', error)
      this.showError()
    }
  }
  
  displayResults(books) {
    if (books.length === 0) {
      this.resultsTarget.innerHTML = `
        <li class="p-4 text-gray-500 text-center">
          検索結果が見つかりませんでした
        </li>
      `
      this.showResults()
      return
    }
    
    this.resultsTarget.innerHTML = books.map(book => {
      // ✅ Base64エンコード
      const bookData = btoa(encodeURIComponent(JSON.stringify(book)))

      return `
        <li>
          <button
            type="button"
            data-action="click->book-search#selectBook"
            data-book="${bookData}"
            class="w-full p-4 text-left hover:bg-gray-50 flex gap-4 border-b border-gray-200"
          >
            ${this.renderThumbnail(book)}
        
            <div class="flex-1">
              <div class="font-semibold text-gray-900">
                ${this.escapeHtml(book.title)}
              </div>
              ${book.author ? `
                <div class="text-sm text-gray-600 mt-1">
                  ${this.escapeHtml(book.author)}
                </div>
              ` : ''}
              ${book.isbn ? `
                <div class="text-xs text-gray-500 mt-1">
                  ISBN: ${book.isbn}
                </div>
              ` : ''}
            </div>
          </button>
        </li>
      `
    }).join('')
    
    this.showResults()
  }
  
  // ✅ サムネイル表示を別メソッドに
  renderThumbnail(book) {
    const fallback = this.noCoverUrlValue

    return `
      <img
        src="${book.thumbnail || fallback}"
        alt="${this.escapeHtml(book.title)}"
        class="w-12 h-16 object-cover rounded"
        onerror="this.src='${fallback}'"
      />
    `
  }
  
  selectBook(event) {
    const book = JSON.parse(
      decodeURIComponent(atob(event.currentTarget.dataset.book))
    )

    // フォーム自動入力
    this.titleTarget.value       = book.title || ""
    this.authorTarget.value      = book.author || ""
    this.publisherTarget.value   = book.publisher || ""
    this.isbnTarget.value        = book.isbn || ""
    this.descriptionTarget.value = book.description || ""
    this.publishedOnTarget.value = book.published_on || ""
    this.googleIdTarget.value    = book.google_books_id || ""
    this.coverUrlTarget.value    = book.thumbnail || ""

    const coverPreviewElement =
      this.element.querySelector('[data-controller="cover-preview"]')

    if (coverPreviewElement) {
      const controller =
        this.application.getControllerForElementAndIdentifier(
          coverPreviewElement,
          "cover-preview"
        )

      controller?.showExternal(book.thumbnail)
    }

    this.hideResults()
  }
  
  showError() {
    this.resultsTarget.innerHTML = `
      <li class="p-4 text-red-500 text-center">
        検索に失敗しました。もう一度お試しください。
      </li>
    `
    this.showResults()
  }
  
  showResults() {
    this.resultsTarget.classList.remove('hidden')
  }
  
  hideResults() {
    this.resultsTarget.classList.add('hidden')
  }
  
  escapeHtml(text) {
    if (!text) return ''
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
