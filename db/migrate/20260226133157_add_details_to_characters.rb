class AddDetailsToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :backstory, :text
    add_column :characters, :plot_role, :text
    add_column :characters, :history, :text
  end
end
