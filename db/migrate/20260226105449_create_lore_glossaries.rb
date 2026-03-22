class CreateLoreGlossaries < ActiveRecord::Migration[8.1]
  def change
    create_table :lore_glossaries do |t|
      t.string :term
      t.text :definition
      t.references :franchise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
