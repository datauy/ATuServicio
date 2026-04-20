class AddSiteToGeoEntity < ActiveRecord::Migration[8.0]
  def change
    add_reference :geo_entities, :site, foreign_key: true
  end
end
