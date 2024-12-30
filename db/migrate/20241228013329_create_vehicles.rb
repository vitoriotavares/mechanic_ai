class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :make_model
      t.integer :year
      t.integer :km
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
