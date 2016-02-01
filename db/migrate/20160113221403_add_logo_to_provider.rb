class AddLogoToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :logo, :string
  end
end
