class CreateUserProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :user_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :work, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
