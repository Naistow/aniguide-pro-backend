class CreateEpisodes < ActiveRecord::Migration[8.1]
  def change
    create_table :episodes do |t|
      t.references :work, null: false, foreign_key: true
      t.integer :episode_number
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
