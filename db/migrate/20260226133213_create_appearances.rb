class CreateAppearances < ActiveRecord::Migration[8.1]
  def change
    create_table :appearances do |t|
      t.references :character, null: false, foreign_key: true
      t.references :work, null: false, foreign_key: true
      t.string :episodes

      t.timestamps
    end
  end
end
