class AddOrdenToPia < ActiveRecord::Migration
  def change
    add_column :pia, :orden, :integer
  end
end
