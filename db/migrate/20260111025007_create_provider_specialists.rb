class ProviderSpecialists < ActiveRecord::Migration[8.0]
  def change
    create_table :provider_specialists do |t|
      t.references :provider, index: true, foreign_key: true
      t.integer :year, index:true
      t.string :period
      t.references :zone, index: true, foreign_key: true
      t.references :specialities, index: false, foreign_key: true
      t.decimal :value, precision: 9, scale: 2
      t.timestamps null: false
    end
  end
end
