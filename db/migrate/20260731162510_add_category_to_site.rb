class AddCategoryToSite < ActiveRecord::Migration[8.0]
  def change
    add_column :sites, :category, :integer
  end
end
