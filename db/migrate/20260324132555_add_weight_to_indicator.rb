class AddWeightToIndicator < ActiveRecord::Migration[8.0]
  def change
    add_column :indicators, :weight, :integer
  end
end
