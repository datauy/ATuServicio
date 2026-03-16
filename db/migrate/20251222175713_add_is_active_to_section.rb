class AddIsActiveToSection < ActiveRecord::Migration[8.0]
  def change
    add_column :sections, :is_active, :boolean
  end
end
