class AddStatusToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :status, :string
  end
end
