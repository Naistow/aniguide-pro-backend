class CreateWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :works do |t|
      t.string :title
      t.integer :release_year
      t.text :plot_summary
      t.string :poster_url
      t.references :franchise, null: false, foreign_key: true
      t.references :media_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
