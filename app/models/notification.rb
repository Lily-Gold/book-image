class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :review
  belongs_to :comment, optional: true

  validates :action_type, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(read: false) }

  def mark_as_read!
    update!(read: true)
  end
end
