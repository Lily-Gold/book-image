class AddUniqueIndexToLikes < ActiveRecord::Migration[8.0]
  def change
    add_index :likes, [ :user_id, :review_id ], unique: true
  end
end
