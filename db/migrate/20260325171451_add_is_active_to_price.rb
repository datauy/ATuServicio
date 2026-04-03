class AddIsActiveToPrice < ActiveRecord::Migration[8.0]
  def change
    add_column :prices, :is_active, :boolean
  end
end
