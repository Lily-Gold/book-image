class AddLimitsAndDefaultsToUsersAndBooks < ActiveRecord::Migration[8.0]
  def change
    # --- books ---
    change_column :books, :author, :string, limit: 100, default: "", null: false
    change_column :books, :publisher, :string, limit: 100, default: "", null: false

    # --- users ---
    change_column :users, :name, :string, limit: 50, null: false
    change_column :users, :avatar_url, :string, limit: 500, default: "avatar.png"
    change_column :users, :provider, :string, limit: 50
    change_column :users, :uid, :string, limit: 100

    # --- index for omniauth ---
    add_index :users, [:provider, :uid], unique: true
  end
end
