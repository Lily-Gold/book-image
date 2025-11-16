class Book < ApplicationRecord
  belongs_to :user, optional: true  # ← 自作投稿時のみユーザー紐付け

  has_many :reviews, dependent: :destroy
  has_one_attached :cover

  validates :title, presence: true, length: { maximum: 120 }
  validates :author, length: { maximum: 100 }
  validates :isbn, length: { maximum: 20 }
  validates :google_books_id, length: { maximum: 80 }
  validates :publisher, length: { maximum: 100 }

  # MVP用の単純検索スコープ（タイトル・著者・ISBN）
  scope :search, ->(keyword) {
    where("title ILIKE :kw OR author ILIKE :kw OR isbn ILIKE :kw", kw: "%#{keyword}%") if keyword.present?
  }
  def cover_variant(size: [ 400, 400 ])
    cover.variant(resize_to_limit: size).processed
  end
end
