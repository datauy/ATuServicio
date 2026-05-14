class AddIsActiveToSite < ActiveRecord::Migration[8.0]
  def change
    add_column :sites, :is_active, :boolean, default: 1
  end
end
