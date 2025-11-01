class CreateImageTags < ActiveRecord::Migration[8.0]
  def change
    create_table :image_tags do |t|
      t.string :name, null: false, limit: 10
      t.string :color, null: false, limit: 7

      t.timestamps
    end

    add_index :image_tags, :name, unique: true
  end
end
