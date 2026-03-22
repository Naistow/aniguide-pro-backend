class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_hash
      t.references :user_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
