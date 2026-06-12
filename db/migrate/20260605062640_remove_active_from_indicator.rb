class RemoveActiveFromIndicator < ActiveRecord::Migration[8.0]
  def change
    remove_column :indicators, :active, :boolean
  end
end
