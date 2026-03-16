class AddDataToIndicator < ActiveRecord::Migration[8.0]
  def change
    add_column :indicators, :section, :integer
    add_column :indicators, :abbr, :string
  end
end
