class AddPublicIdToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :public_id, :string, limit: 16
    add_index  :reviews, :public_id, unique: true
  end
end
