class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :review, null: false, foreign_key: true

      t.string :action_type, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    # いいね通知は同一ユーザー×同一レビューで1回だけ
    add_index :notifications,
              [:user_id, :actor_id, :review_id, :action_type],
              unique: true,
              where: "action_type = 'like'",
              name: "index_notifications_unique_like"
  end
end
