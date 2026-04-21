class AddColumnsToFavorites < ActiveRecord::Migration[7.0] # (Цифры в скобках могут отличаться, не трогай их)
  def change
    add_column :favorites, :work_id, :integer
    # Строку с character_id мы отсюда удалили!
  end
end