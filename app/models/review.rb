class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :image_tag

  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :book

  validates :content, presence: true, length: { maximum: 5000 }
  validates :is_spoiler, inclusion: { in: [ true, false ] }

  validates :image_tag_id, presence: true

  validates_associated :book

  before_create :set_public_id

  scope :same_book, ->(review) {
    # book または google_books_id がない場合は空の結果を返す
    return none if review.book.blank? || review.book.google_books_id.blank?

    joins(:book)
      .where(books: { google_books_id: review.book.google_books_id })
      .where.not(id: review.id)
      .order(created_at: :desc)
  }

  def to_param
    public_id
  end

  def likes_count
    likes.count
  end

  private

  def assign_existing_book
    return unless book&.google_books_id.present?

    if book.remove_cover == "1" ||
       book.remove_cover_url == "1" ||
       book.cover.attached?
      return
    end

    existing_book = Book.find_by(google_books_id: book.google_books_id)
    self.book = existing_book if existing_book
  end

  def set_public_id
    return if public_id.present?

    self.public_id = generate_unique_public_id
  end

  def generate_unique_public_id
    loop do
      token = SecureRandom.alphanumeric(16).downcase
      break token unless self.class.exists?(public_id: token)
    end
  end
end
