class AddStructureToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :estructura_primaria, :integer, default: 0
    add_column :providers, :estructura_secundaria, :integer, default: 0
    add_column :providers, :estructura_ambulatorio, :integer, default: 0
    add_column :providers, :estructura_urgencia, :integer, default: 0
  end
end
