FactoryBot.define do
  factory :book do
    title { "テスト本タイトル" }
    author { "テスト著者" }
    publisher { "テスト出版社" }
    published_on { Date.today }
    isbn { Faker::Code.isbn }
    google_books_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    description { "本の説明文です" }
    cover_url { "https://example.com/sample.jpg" }

    association :user
  end
end
