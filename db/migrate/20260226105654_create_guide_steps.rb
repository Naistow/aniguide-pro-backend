class CreateGuideSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :guide_steps do |t|
      t.integer :step_number
      t.text :editor_note
      t.references :watch_guide, null: false, foreign_key: true
      t.references :work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
