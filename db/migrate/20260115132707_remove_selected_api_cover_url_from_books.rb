class RemoveSelectedApiCoverUrlFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :selected_api_cover_url, :string
  end
end
