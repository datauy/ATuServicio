class AddTitleToIndicator < ActiveRecord::Migration[8.0]
  def change
    add_column :indicators, :title, :string
  end
end
