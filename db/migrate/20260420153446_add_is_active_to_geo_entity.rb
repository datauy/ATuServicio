class AddIsActiveToGeoEntity < ActiveRecord::Migration[8.0]
  def change
    add_column :geo_entities, :is_active, :boolean
  end
end
