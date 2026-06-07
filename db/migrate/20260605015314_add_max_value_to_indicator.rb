class AddMaxValueToIndicator < ActiveRecord::Migration[8.0]
  def change
    add_column :indicators, :max_value, :decimal
  end
end
