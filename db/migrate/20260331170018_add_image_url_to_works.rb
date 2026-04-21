class AddImageUrlToWorks < ActiveRecord::Migration[8.1]
  def change
    add_column :works, :image_url, :string
  end
end
