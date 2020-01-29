class AddNewRrhhCad < ActiveRecord::Migration
  def change
    [
      :cantidad_cad_medicina_rural, :cantidad_cad_imagenologia, :cantidad_cad_anestesia
    ].each do |column|
      add_column :providers, column, :decimal, default: nil
    end
  end
end
