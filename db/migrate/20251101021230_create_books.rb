class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      # --- 基本情報（MVP時点ではユーザー手入力） ---
      t.string  :title, null: false, limit: 120
      t.string  :author, limit: 100
      t.string  :publisher
      t.date    :published_on

      # --- 識別情報（将来的にAPI連携で利用） ---
      t.string  :isbn, limit: 20
      t.string  :google_books_id, limit: 80

      # --- 詳細情報 ---
      t.text    :description
      t.string  :cover_url, limit: 500  # 書影URL（外部API想定）

      # --- 自作投稿用（ユーザー紐付け） ---
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end

    # --- インデックス ---
    add_index :books, :google_books_id, unique: true
    add_index :books, :isbn
  end
end
