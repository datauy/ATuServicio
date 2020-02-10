class RemoveFieldsFromSites < ActiveRecord::Migration
  def up
    ['servicio_de_urgencia', 'alergista', 'anestesiologia', 'cardiologia',
  'cirugia', 'cirugia_reparadora', 'cirugia_vascular', 'deportologia',
  'dermatologia', 'endocrinolgia', 'fisiatria', 'gastroenterologia',
  'geriatria', 'ginecologia', 'hematologia', 'infectologia', 'medicina_general',
  'medicina_interna', 'medicina_intensiva', 'nefrologia', 'neonatologia',
  'neumologia', 'neurocirugia', 'neurologia', 'neuropediatria', 'odontologia',
  'oncologia', 'otorrinolaringologia', 'pediatria', 'psiquiatria',
  'psiquiatria_infantil', 'reumatologia', 'traumatologia', 'urologia'].each do |column|
      remove_column :sites, column
    end
  end

  def down
    [
      {tipo: :boolean, name: :servicio_de_urgencia},
      {tipo: :boolean, name: :alergista},
      {tipo: :boolean, name: :anestesiologia},
      {tipo: :boolean, name: :cardiologia},
      {tipo: :boolean, name: :cirugia},
      {tipo: :boolean, name: :cirugia_reparadora},
      {tipo: :boolean, name: :cirugia_vascular},
      {tipo: :boolean, name: :deportologia},
      {tipo: :boolean, name: :dermatologia},
      {tipo: :boolean, name: :endocrinolgia},
      {tipo: :boolean, name: :fisiatria},
      {tipo: :boolean, name: :gastroenterologia},
      {tipo: :boolean, name: :geriatria},
      {tipo: :boolean, name: :ginecologia},
      {tipo: :boolean, name: :hematologia},
      {tipo: :boolean, name: :infectologia},
      {tipo: :boolean, name: :medicina_general},
      {tipo: :boolean, name: :medicina_interna},
      {tipo: :boolean, name: :medicina_intensiva},
      {tipo: :boolean, name: :nefrologia},
      {tipo: :boolean, name: :neonatologia},
      {tipo: :boolean, name: :neumologia},
      {tipo: :boolean, name: :neurocirugia},
      {tipo: :boolean, name: :neurologia},
      {tipo: :boolean, name: :neuropediatria},
      {tipo: :boolean, name: :odontologia},
      {tipo: :boolean, name: :oncologia},
      {tipo: :boolean, name: :otorrinolaringologia},
      {tipo: :boolean, name: :pediatria},
      {tipo: :boolean, name: :psiquiatria},
      {tipo: :boolean, name: :psiquiatria_infantil},
      {tipo: :boolean, name: :reumatologia},
      {tipo: :boolean, name: :traumatologia},
      {tipo: :boolean, name: :urologia}
    ].map(&:values).each do |tipo, name|
      add_column :sites, name, tipo
    end
  end
end
