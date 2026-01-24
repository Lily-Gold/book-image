class AddCommentIdToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :comment_id, :bigint
    add_index :notifications, :comment_id
    add_foreign_key :notifications, :comments
  end
end
