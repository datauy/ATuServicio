require 'csv'

class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
    end

    ['estructura', 'metas', 'precios', 'tiempos_espera', 'satisfaccion_derechos', 'rrhh'].each do |group|
      get_columns(group)['definition'].each do |type, column_names|
        column_names.each do |column_name|
          if type.to_sym == :decimal
            add_column :providers, column_name, :decimal, precision: 9, scale: 2
          else
            add_column :providers, column_name, type
        end
        end
      end
    end
  end

  # TODO: find a way to not to repeat this in migration
  def metadata
    YAML.load_file(File.join(Rails.root, "config", "metadata.yml"))
  end

  def get_columns(filename)
    metadata[filename]
  end
end
