class Api::GoogleBooksController < ApplicationController
  skip_before_action :authenticate_user!, only: :search

  def search
    query = params[:q]

    if query.blank?
      render json: { error: "検索ワードがありません" }, status: :bad_request
      return
    end

    begin
      escaped = CGI.escape(query)

      is_isbn = isbn_query?(query)

      # ISBNかどうかを判定
      url =
        if is_isbn
          isbn = normalize_isbn(query)
          "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&maxResults=10"
        else
          "https://www.googleapis.com/books/v1/volumes?q=#{escaped}&langRestrict=ja&maxResults=20"
        end

      response = Faraday.get(url) do |req|
        req.options.timeout = 5
        req.options.open_timeout = 2
      end

      unless response.success?
        render json: { error: "Google Books APIからのデータ取得に失敗しました" },
               status: :service_unavailable
        return
      end

      data = JSON.parse(response.body)
      items = data["items"] || []

      if items.empty?
        render json: []
        return
      end

      books = items.map { |item| format_book(item) }

      # ISBNで検索した場合は、スコアリング処理をスキップ
      if is_isbn
        input_isbn = normalize_isbn(query)

        exact_books = books.select do |book|
          isbn_match?(book[:isbn], input_isbn)
        end

        render json: exact_books.first(1)
        return
      end

      # トークン化(正規化を先に実行)
      tokens = query
        .unicode_normalize(:nfkc)
        .split(/[\s\u3000]+/)
        .map { |t| normalize(t) }
        .reject(&:blank?)

      # スコアリング検索
      filtered_books = books.map do |book|
        normalized_title = normalize(book[:title])
        normalized_author = normalize(book[:author])

        # 一致度を計算(ISBNは除外)
        score = tokens.sum do |token|
          if normalized_title.include?(token)
            token.length * 3   # タイトル最優先
          elsif normalized_author.include?(token)
            token.length * 2   # 著者は次に優先
          else
            0
          end
        end

        book.merge(score: score)
      end

      # スコアが0より大きいものだけ抽出してソート
      filtered = filtered_books
        .select { |b| b[:score] > 0 }
        .sort_by { |b| -b[:score] }

      render json: filtered.first(10)

    rescue Faraday::TimeoutError
      render json: { error: "APIへの接続がタイムアウトしました" }, status: :gateway_timeout
    rescue Faraday::ConnectionFailed
      render json: { error: "APIへの接続に失敗しました" }, status: :service_unavailable
    rescue JSON::ParserError
      render json: { error: "レスポンスの解析に失敗しました" }, status: :internal_server_error
    rescue => e
      Rails.logger.error("Google Books API Error: #{e.message}")
      render json: { error: "予期しないエラーが発生しました" }, status: :internal_server_error
    end
  end

  private

  def format_book(item)
    info = item["volumeInfo"] || {}
    image_links = info["imageLinks"] || {}

    cover_url =
      image_links["extraLarge"] ||
      image_links["large"] ||
      image_links["medium"] ||
      image_links["thumbnail"]

    if cover_url
      cover_url = cover_url
        .gsub(/^http:/, "https:")
        .gsub(/zoom=\d/, "zoom=3")
        .gsub("&edge=curl", "")
    end

    {
      google_books_id: item["id"],
      title: info["title"],
      author: (info["authors"] || []).join(", "),
      publisher: info["publisher"],
      published_on: parse_published_date(info["publishedDate"]),
      description: info["description"],
      isbn: extract_isbn(info["industryIdentifiers"]),
      thumbnail: cover_url
    }
  end

  def extract_isbn(identifiers)
    return nil if identifiers.blank?

    isbn13 = identifiers.find { |i| i["type"] == "ISBN_13" }
    isbn10 = identifiers.find { |i| i["type"] == "ISBN_10" }

    isbn13&.dig("identifier") || isbn10&.dig("identifier")
  end

  def parse_published_date(date_string)
    return nil if date_string.blank?

    return Date.parse(date_string) if date_string.match?(/^\d{4}-\d{2}-\d{2}$/)
    return Date.parse("#{date_string}-01") if date_string.match?(/^\d{4}-\d{2}$/)
    return Date.parse("#{date_string}-01-01") if date_string.match?(/^\d{4}$/)

    nil
  rescue Date::Error
    nil
  end

  def normalize(text)
    return "" if text.blank?

    text
      .unicode_normalize(:nfkc)
      .tr("　", " ")
      .strip
      .downcase
      .gsub(/\s+/, "")
      .gsub(/[[:punct:]]/, "")
      .gsub(/[・、。「」『』【】（）]/, "")
  end

  # ISBNかどうかを判定
  def isbn_query?(query)
    normalized = normalize_isbn(query)

    # ISBN-10またはISBN-13の形式か確認
    return false unless [ 10, 13 ].include?(normalized.length)

    # ISBN-10の場合、最後の文字はXも許可
    if normalized.length == 10
      normalized.match?(/^\d{9}[\dXx]$/)
    else
      # ISBN-13の場合、すべて数字
      normalized.match?(/^\d{13}$/)
    end
  end

  # ISBNの正規化(ハイフンやスペースを削除)
  def normalize_isbn(query)
    query.gsub(/[^0-9Xx]/, "").upcase
  end

  def isbn_match?(book_isbn, input_isbn)
    b = normalize_isbn(book_isbn)
    i = normalize_isbn(input_isbn)

    return false if b.blank? || i.blank?

    b == i ||
      isbn10_to_13(b) == i ||
      isbn10_to_13(i) == b
  end

  def isbn10_to_13(isbn)
    return nil unless isbn.length == 10
    return nil unless isbn[0, 9].match?(/^\d{9}$/)

    body = "978" + isbn[0, 9]

    sum = body.chars.each_with_index.sum do |char, idx|
      digit = char.to_i
      idx.even? ? digit : digit * 3
    end

    check = (10 - (sum % 10)) % 10
    body + check.to_s
  end
end
