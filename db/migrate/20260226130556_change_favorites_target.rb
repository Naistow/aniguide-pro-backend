class ChangeFavoritesTarget < ActiveRecord::Migration[8.1]
  def change
    remove_reference :favorites, :franchise, foreign_key: true
    add_reference :favorites, :character, foreign_key: true
  end
end