class AddSelectedApiCoverUrlToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :selected_api_cover_url, :string
  end
end
