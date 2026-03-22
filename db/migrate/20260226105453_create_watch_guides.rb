class CreateWatchGuides < ActiveRecord::Migration[8.1]
  def change
    create_table :watch_guides do |t|
      t.string :title
      t.text :description
      t.references :franchise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
