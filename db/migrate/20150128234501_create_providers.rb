require 'csv'

class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
    end

    ['estructura', 'metas', 'precios'].each do |group|
      get_columns(group)['definition'].each do |type, column_names|
        column_names.each do |column_name|
          add_column :providers, column_name.to_sym, type.to_sym
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
