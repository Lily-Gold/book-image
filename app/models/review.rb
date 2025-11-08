class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :image_tag

  validates :content, presence: true, length: { maximum: 5000 }
  validates :is_spoiler, inclusion: { in: [true, false] }

  enum :is_spoiler, { safe: false, spoiler: true }
end
