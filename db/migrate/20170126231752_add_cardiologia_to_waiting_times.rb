class AddCardiologiaToWaitingTimes < ActiveRecord::Migration
  def change
    add_column :providers, :tiempo_espera_cardiologia, :decimal unless column_exists?(:providers, :tiempo_espera_cardiologia)
  end
end
