class AddFieldsToSite < ActiveRecord::Migration[8.0]
  def change
    add_column :sites, :stype, :integer
    add_column :sites, :address_comp, :string
    add_column :sites, :highway, :string
    add_column :sites, :highway_km, :string
  end
end
