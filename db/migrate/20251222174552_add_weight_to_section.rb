class AddWeightToSection < ActiveRecord::Migration[8.0]
  def change
    add_column :sections, :weight, :integer
  end
end
