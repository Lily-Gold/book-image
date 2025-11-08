class ImageTag < ApplicationRecord
  has_many :reviews, dependent: :nullify

  validates :name,  presence: true, length: { maximum: 10 }, uniqueness: true
  validates :color, presence: true, length: { is: 7 }
end
