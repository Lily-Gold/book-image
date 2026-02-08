class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :content, presence: true, length: { minimum: 5, maximum: 5000 }
end
