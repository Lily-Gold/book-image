class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :image_tag

  has_many :likes, dependent: :destroy

  accepts_nested_attributes_for :book

  validates :content, presence: true, length: { maximum: 5000 }
  validates :is_spoiler, inclusion: { in: [ true, false ] }

  validates :image_tag_id, presence: true

  validates_associated :book

  before_create :set_public_id

  def to_param
    public_id
  end

  def likes_count
    likes.count
  end

  private

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
