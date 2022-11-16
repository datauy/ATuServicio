class AddSectionToIndicator < ActiveRecord::Migration
  def change
    add_column :indicators, :section, :string
  end
end
