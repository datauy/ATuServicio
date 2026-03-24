class AddDataToIndicator < ActiveRecord::Migration[8.0]
  def change
    add_reference :indicators, :section, index: true, foreign_key: true, null: false
    add_column :indicators, :abbr, :string
  end
end
