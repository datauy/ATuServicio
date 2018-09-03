class UpdateGoalsColumns < ActiveRecord::Migration
  def change
    [:captacion_rn, :control_desarrollo, :control_embarazo, :control_hiv_vdrl, :control_pauta_45_64].each do |meta|
      add_column :providers, a, :decimal unless column_exists?(:providers, meta)
    end
    add_column :providers, :indice_cesareas, :integer unless column_exists?(:providers, :indice_cesareas)

    remove_column :providers, :meta_ninos_controlados if column_exists?(:providers, :meta_ninos_controlados)
    remove_column :providers, :meta_embarazadas if column_exists?(:providers, :meta_embarazadas)
    remove_column :providers, :espacio_adolescente if column_exists?(:providers, :espacio_adolescente)
  end
end
