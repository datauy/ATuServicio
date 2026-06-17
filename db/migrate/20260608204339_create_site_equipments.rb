class CreateSiteEquipments < ActiveRecord::Migration[8.0]
  def change
    create_table :site_equipments do |t|
      t.references :site, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.integer :year
      t.string :period

      t.timestamps
    end
  end
end
