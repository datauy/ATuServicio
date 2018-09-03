class AddColumnsToRrhh2018 < ActiveRecord::Migration
  def change
    %i[medicina_emergencia_pediatrica_cantidad_cad
       proporcion_trabajadores_seminario_2017].each do |col|
      add_column :providers, col, :decimal
    end
  end
end
