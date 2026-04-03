class AddWeightToPrice < ActiveRecord::Migration[8.0]
  def change
    add_column :prices, :weight, :integer
  end
end
