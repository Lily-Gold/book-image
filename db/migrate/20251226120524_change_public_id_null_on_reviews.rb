class ChangePublicIdNullOnReviews < ActiveRecord::Migration[8.0]
  def change
    change_column_null :reviews, :public_id, false
  end
end
