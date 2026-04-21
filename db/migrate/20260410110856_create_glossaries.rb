class CreateGlossaries < ActiveRecord::Migration[8.1]
  def change
    create_table :glossaries do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.references :franchise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
