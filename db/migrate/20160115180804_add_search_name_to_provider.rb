class AddSearchNameToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :search_name, :string
  end
end
