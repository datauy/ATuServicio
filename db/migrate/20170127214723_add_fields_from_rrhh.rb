class AddFieldsFromRrhh < ActiveRecord::Migration
  def change
    add_column :providers, :especialidades_medicas_cantidad_cad, :decimal
    add_column :providers, :cirugia_general_cantidad_cad, :decimal
    add_column :providers, :medicina_emergencia_cantidad_cad, :decimal
  end
end
