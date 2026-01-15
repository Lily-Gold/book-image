class Book < ApplicationRecord
  include ImageProcessable

  belongs_to :user, optional: true

  has_many :reviews, dependent: :destroy
  has_one_attached :cover

  attr_accessor :remove_cover
  attr_accessor :remove_cover_url

  validates :title, presence: true, length: { maximum: 120 }
  validates :author, length: { maximum: 100 }
  validates :isbn, length: { maximum: 20 }
  validates :google_books_id, length: { maximum: 80 }
  validates :publisher, length: { maximum: 100 }

  before_validation :apply_remove_cover_url
  before_validation :normalize_text_fields
  before_validation :normalize_cover_url

  scope :search, ->(keyword) {
    where("title ILIKE :kw OR author ILIKE :kw OR isbn ILIKE :kw", kw: "%#{keyword}%") if keyword.present?
  }

  # ★ Cloudinary では不要（ActiveStorage の variant）
  # def cover_variant(size: [400, 400])
  #   cover.variant(resize_to_limit: size).processed
  # end

  validate :validate_cover_format_and_size

  private

  def apply_remove_cover_url
    return unless remove_cover_url == "1"

    self.cover_url = nil
  end

  def normalize_text_fields
    %i[title author publisher description isbn].each do |field|
      next if self[field].blank?

      # 全角英数字 → 半角英数字
      self[field] = self[field].tr("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")

      # ISBN だけハイフン除去
      self[field] = self[field].delete("-") if field == :isbn
    end
  end

  def normalize_cover_url
    return if cover_url.blank?

    self.cover_url = cover_url
      .gsub(/^http:/, "https:")
      .gsub(/zoom=\d/, "zoom=3")
      .gsub("&edge=curl", "")
  end

  # ▼ 画像チェック
  def validate_cover_format_and_size
    return unless cover.attached?

    acceptable_types = [ "image/jpeg", "image/png" ]

    unless acceptable_types.include?(cover.blob.content_type)
      errors.add(:cover, "は jpg / jpeg / png のみアップロードできます。")
    end

    if cover.blob.byte_size > 5.megabytes
      errors.add(:cover, "のサイズは5MB以下にしてください。")
    end
  end
end
