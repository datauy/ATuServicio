class UpdateGoalsColumns < ActiveRecord::Migration
  def change
    add_column :providers, :captacion_rn, :decimal
    add_column :providers, :control_desarrollo, :decimal
    add_column :providers, :control_embarazo, :decimal
    add_column :providers, :control_hiv_vdrl, :decimal
    add_column :providers, :control_pauta_45_64, :decimal
    add_column :providers, :indice_cesareas, :integer
    remove_column :providers, :meta_ninos_controlados
    remove_column :providers, :meta_embarazadas
    remove_column :providers, :espacio_adolescente
  end
end
