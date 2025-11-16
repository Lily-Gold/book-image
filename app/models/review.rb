class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :image_tag

  accepts_nested_attributes_for :book

  validates :content, presence: true, length: { maximum: 5000 }
  validates :is_spoiler, inclusion: { in: [ true, false ] }
end
