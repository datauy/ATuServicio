class AddFieldsFromRrhh < ActiveRecord::Migration
  def change
    unless column_exists? :providers, :especialidades_medicas_cantidad_cad
    	add_column :providers, :especialidades_medicas_cantidad_cad, :decimal
    end
    unless column_exists? :providers, :cirugia_general_cantidad_cad
    	add_column :providers, :cirugia_general_cantidad_cad, :decimal
    end
    unless column_exists? :providers, :medicina_emergencia_cantidad_cad
    	add_column :providers, :medicina_emergencia_cantidad_cad, :decimal
	end
  end
end
