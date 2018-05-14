class UpdateGoalsColumns < ActiveRecord::Migration
  def change
    unless column_exists? :providers, :captacion_rn
        add_column :providers, :captacion_rn, :decimal
    end
    unless column_exists? :providers, :control_desarrollo
        add_column :providers, :control_desarrollo, :decimal
    end
    unless column_exists? :providers, :control_embarazo
        add_column :providers, :control_embarazo, :decimal
    end
    unless column_exists? :providers, :control_hiv_vdrl
        add_column :providers, :control_hiv_vdrl, :decimal
    end
    unless column_exists? :providers, :control_pauta_45_64
        add_column :providers, :control_pauta_45_64, :decimal
    end
    unless column_exists? :providers, :indice_cesareas
        add_column :providers, :indice_cesareas, :integer
    end
    if column_exists? :providers, :meta_ninos_controlados
        remove_column :providers, :meta_ninos_controlados
    end
    if column_exists? :providers, :meta_embarazadas
        remove_column :providers, :meta_embarazadas
    end
    if column_exists? :providers, :espacio_adolescente
        remove_column :providers, :espacio_adolescente
    end
  end
end
