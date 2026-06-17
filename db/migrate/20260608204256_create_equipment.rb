class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.string :etype
      t.string :brand
      t.string :model
      t.integer :year

      t.timestamps
    end
  end
end
