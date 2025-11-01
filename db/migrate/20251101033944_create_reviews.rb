class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user,      null: false, foreign_key: true
      t.references :book,      null: false, foreign_key: true
      t.references :image_tag, null: false, foreign_key: true

      t.text    :content, null: false
      t.boolean :is_spoiler, default: false, null: false

      t.timestamps
    end
  end
end
