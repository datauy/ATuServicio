class AddEspacioAdolescenteToProviders < ActiveRecord::Migration
  def change
    remove_column :providers, :espacio_adolescente if column_exists?(:providers, :espacio_adolescente)
    add_column :providers, :espacio_adolescente, :string
  end
end
