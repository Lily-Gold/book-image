class Book < ApplicationRecord
  belongs_to :user, optional: true

  has_many :reviews, dependent: :destroy
  has_one_attached :cover

  attr_accessor :remove_cover

  validates :title, presence: true, length: { maximum: 120 }
  validates :author, length: { maximum: 100 }
  validates :isbn, length: { maximum: 20 }
  validates :google_books_id, length: { maximum: 80 }
  validates :publisher, length: { maximum: 100 }

  # ★ 画像の形式・サイズチェック（jpg / jpeg / png、5MBまで）
  validate :validate_cover_format_and_size

  # MVP用の単純検索スコープ（タイトル・著者・ISBN）
  scope :search, ->(keyword) {
    where("title ILIKE :kw OR author ILIKE :kw OR isbn ILIKE :kw", kw: "%#{keyword}%") if keyword.present?
  }

  def cover_variant(size: [ 400, 400 ])
    cover.variant(resize_to_limit: size).processed
  end

  private

  # ▼ 画像チェック用メソッド
  def validate_cover_format_and_size
    return unless cover.attached?

    # 許可する拡張子（MIMEタイプ）
    acceptable_types = [ "image/jpeg", "image/png" ]

    unless acceptable_types.include?(cover.blob.content_type)
      errors.add(:cover, "は jpg / jpeg / png のみアップロードできます。")
    end

    # サイズ（5MB = 5 * 1024 * 1024）
    if cover.blob.byte_size > 5.megabytes
      errors.add(:cover, "のサイズは5MB以下にしてください。")
    end
  end
end
