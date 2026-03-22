class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.text :biography
      t.string :photo_url
      t.references :franchise, null: false, foreign_key: true
      t.references :character_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
