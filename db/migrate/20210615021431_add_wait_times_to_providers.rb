class AddWaitTimesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :tiempo_espera_medicina_general_presencial, :numeric
    add_column :providers, :tiempo_espera_pediatria_presencial, :numeric
    add_column :providers, :tiempo_espera_cirugia_general_presencial, :numeric
    add_column :providers, :tiempo_espera_ginecotocologia_presencial, :numeric
    add_column :providers, :tiempo_espera_cardiologia_presencial, :numeric
    add_column :providers, :tiempo_espera_medicina_general_virtual, :numeric
    add_column :providers, :tiempo_espera_pediatria_virtual, :numeric
    add_column :providers, :tiempo_espera_cirugia_general_virtual, :numeric
    add_column :providers, :tiempo_espera_ginecotocologia_virtual, :numeric
    add_column :providers, :tiempo_espera_cardiologia_virtual, :numeric
  end
end
