class AddNombreToImae < ActiveRecord::Migration
  def change
    add_column :imaes, :nombre, :string
  end
end
