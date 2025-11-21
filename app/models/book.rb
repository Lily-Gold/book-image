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

  # ★ 全角 → 半角の一括正規化
  before_validation :normalize_text_fields

  scope :search, ->(keyword) {
    where("title ILIKE :kw OR author ILIKE :kw OR isbn ILIKE :kw", kw: "%#{keyword}%") if keyword.present?
  }

  def cover_variant(size: [400, 400])
    cover.variant(resize_to_limit: size).processed
  end

  private

  def normalize_text_fields
    # 本情報に関する文字列をまとめて正規化
    %i[title author publisher description isbn].each do |field|
      next if self[field].blank?

      # 全角英数字 → 半角英数字
      self[field] = self[field].tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")

      # ISBN だけハイフン除去
      self[field] = self[field].delete("-") if field == :isbn
    end
  end

  # ▼ 画像チェック
  def validate_cover_format_and_size
    return unless cover.attached?

    acceptable_types = ["image/jpeg", "image/png"]

    unless acceptable_types.include?(cover.blob.content_type)
      errors.add(:cover, "は jpg / jpeg / png のみアップロードできます。")
    end

    if cover.blob.byte_size > 5.megabytes
      errors.add(:cover, "のサイズは5MB以下にしてください。")
    end
  end
end
