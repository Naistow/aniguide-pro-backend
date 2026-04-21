class AddCoordinatesToWorks < ActiveRecord::Migration[8.1]
  def change
    add_column :works, :pos_x, :integer
    add_column :works, :pos_y, :integer
    add_column :works, :parent_id, :integer
  end
end
