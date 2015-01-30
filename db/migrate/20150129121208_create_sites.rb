class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :provider, index: true

      t.timestamps null: false
    end
    add_foreign_key :sites, :providers

    # Add columns
    column_definitions('sedes')['definition'].each do |type, column_names|
      column_names.each do |column_name|
        add_column :sites, column_name, type
      end
    end
  end

  # TODO: find a way to not to repeat this in migration
  def column_definitions(filename)
    metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml"))
    metadata[filename]
  end
end
