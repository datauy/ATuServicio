class AddInfoToSection < ActiveRecord::Migration[8.0]
  def change
    add_column :sections, :info, :text
  end
end
