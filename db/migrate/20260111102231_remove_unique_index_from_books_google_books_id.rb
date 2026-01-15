class RemoveUniqueIndexFromBooksGoogleBooksId < ActiveRecord::Migration[8.0]
  def change
    remove_index :books, :google_books_id
    add_index :books, :google_books_id
  end
end
