class ChangeIntegerToDecimalCesareas < ActiveRecord::Migration
  def change
    change_column :providers, :indice_cesareas, :decimal
  end
end
