class AddStateToGeoEntity < ActiveRecord::Migration[8.0]
  def change
    add_reference :geo_entities, :state, foreign_key: { to_table: :zones }
  end
end
