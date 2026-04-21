class AddDescriptionToWorks < ActiveRecord::Migration[8.1]
  def change
    add_column :works, :description, :text
  end
end
