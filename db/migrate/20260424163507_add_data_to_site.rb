class AddDataToSite < ActiveRecord::Migration[8.0]
  def change
    add_column :sites, :phone, :string
    add_column :sites, :web, :string
    add_column :sites, :email, :string
  end
end
