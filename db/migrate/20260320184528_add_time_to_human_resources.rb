class AddTimeToHumanResources < ActiveRecord::Migration[8.0]
  def change
    add_column :human_resources, :year, :integer
    add_column :human_resources, :period, :string
  end
end
