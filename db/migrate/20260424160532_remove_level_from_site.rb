class RemoveLevelFromSite < ActiveRecord::Migration[8.0]
  def change
    remove_column :sites, :level, :integer
  end
end
