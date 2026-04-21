class AddDurationToEpisodes < ActiveRecord::Migration[8.1]
  def change
    add_column :episodes, :duration, :string
  end
end
