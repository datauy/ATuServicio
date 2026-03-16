class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.references :zone, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :address
      t.references :provider, null: false, foreign_key: true
      t.integer :level

      t.timestamps
    end
  end
end
