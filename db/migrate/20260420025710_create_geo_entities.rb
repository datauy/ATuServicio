class CreateGeoEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :geo_entities do |t|
      t.string :gtype
      t.string :name
      t.text :description
      t.references :zone, null: false, foreign_key: true

      t.timestamps
    end
  end
end
