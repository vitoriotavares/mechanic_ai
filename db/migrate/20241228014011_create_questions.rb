class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.string :mark_model
      t.string :km
      t.integer :year
      t.text :problem
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
