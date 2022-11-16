class CreateProviderRelations < ActiveRecord::Migration
  def change
    create_table :provider_relations do |t|
      t.references :provider, index: true, foreign_key: true, required: true
      t.integer :year, index:true
      t.integer :stage
      t.references :state, index: true, foreign_key: true
      t.references :specialist, index: false, foreign_key: true
      t.decimal :indicator_value, precision: 9, scale: 2
      t.timestamps null: false
    end
  end
end
