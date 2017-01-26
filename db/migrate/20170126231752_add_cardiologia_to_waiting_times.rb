class AddCardiologiaToWaitingTimes < ActiveRecord::Migration
  def change
    add_column :providers, :tiempo_espera_cardiologia, :decimal
  end
end
