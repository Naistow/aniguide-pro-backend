class CreateJoinTableCharactersEpisodes < ActiveRecord::Migration[8.1]
  def change
    create_join_table :characters, :episodes do |t|
      # t.index [:character_id, :episode_id]
      # t.index [:episode_id, :character_id]
    end
  end
end
