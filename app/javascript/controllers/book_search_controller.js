import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  
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
    if (book.thumbnail && book.thumbnail !== 'null') {
      return `
        <img 
          src="${book.thumbnail}" 
          alt="${this.escapeHtml(book.title)}"
          class="w-12 h-16 object-cover rounded"
          onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden')"
        />
        <div class="w-12 h-16 bg-gray-200 rounded items-center justify-center hidden">
          <span class="text-gray-400 text-xs">No Image</span>
        </div>
      `
    } else {
      return `
        <div class="w-12 h-16 bg-gray-200 rounded flex items-center justify-center">
          <span class="text-gray-400 text-xs">No Image</span>
        </div>
      `
    }
  }
  
  selectBook(event) {
    const button = event.currentTarget
    // ✅ Base64デコード
    const book = JSON.parse(
      decodeURIComponent(atob(button.dataset.book))
    )
    
    console.log("選択された本:", book)
    
    // TODO: フォームに自動入力する処理(次のステップ)
    alert(`選択: ${book.title}`)
    
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
