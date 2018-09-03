class AddFieldsFromRrhh < ActiveRecord::Migration
  def change
    [:especialidades_medicas_cantidad_cad, :cirugia_general_cantidad_cad, :medicina_emergencia_cantidad_cad].each do |meta|
      add_column :providers, meta, :decimal unless column_exists?(:providers, meta)
    end
  end
end
