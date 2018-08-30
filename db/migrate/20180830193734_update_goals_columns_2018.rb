class UpdateGoalsColumns2018 < ActiveRecord::Migration
  def change
    remove_column :providers, :control_embarazo if column_exists?(:providers, :control_embarazo)
    remove_column :providers, :control_hiv_vdrl if column_exists?(:providers, :control_hiv_vdrl)
    remove_column :providers, :control_pauta_45_64 if column_exists?(:providers, :control_pauta_45_64)

    %i[control_embarazo_hiv_vdrl control_pauta_25_a_64_hipertensos
       capacitacion_infarto_st_elevado indice_cesareas].each do |meta|
      add_column :providers, meta, :decimal unless column_exists?(:providers, meta)
    end
  end
end
