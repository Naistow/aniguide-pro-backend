class CreateFranchises < ActiveRecord::Migration[8.1]
  def change
    create_table :franchises do |t|
      t.string :name
      t.string :theme
      t.text :description

      t.timestamps
    end
  end
end
