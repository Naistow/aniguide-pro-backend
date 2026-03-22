class CreateCharacterRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :character_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
