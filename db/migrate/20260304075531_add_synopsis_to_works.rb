class AddSynopsisToWorks < ActiveRecord::Migration[8.1]
  def change
    add_column :works, :synopsis, :text
  end
end
