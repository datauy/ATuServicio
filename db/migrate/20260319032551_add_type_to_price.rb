class AddTypeToPrice < ActiveRecord::Migration[8.0]
  def change
    add_column :prices, :ptype, :integer
  end
end
