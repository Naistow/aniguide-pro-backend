class CreateEpisodeAppearances < ActiveRecord::Migration[8.1]
  def change
    create_table :episode_appearances do |t|
      t.references :character, null: false, foreign_key: true
      t.references :episode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
