require 'csv'

class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      # t.string :nombre_abreviado
      # t.string :nombre_completo
      # t.string :web
      # t.integer :afiliados
      # t.decimal :meta_medico_referencia
      # t.decimal :meta_ninos_controlados
      # t.decimal :meta_embarazadas
      # t.boolean :espacio_adolescente
      # t.text :comunicacion
    end

    ['estructura', 'metas', 'precios'].each do |group|
      get_columns(group)['definition'].each do |type, column_names|
        column_names.each do |column_name|
          add_column :providers, column_name.to_sym, type.to_sym
        end
      end
    end
  end

  def metadata
    YAML.load_file(File.join(Rails.root, "db", "data", "metadata.yml"))
  end

  def get_columns(filename)
    metadata[filename]
  end
end
