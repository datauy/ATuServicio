class AddServiciosAtencionAdolescentesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :servicios_atencion_adolescentes, :boolean
  end
end
