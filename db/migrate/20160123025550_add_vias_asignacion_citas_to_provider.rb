class AddViasAsignacionCitasToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :vias_asignacion_citas, :string
  end
end
