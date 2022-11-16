class AddAbbreviationToIndicator < ActiveRecord::Migration
  def change
    add_column :indicators, :abbr, :string
  end
end
