class AddIsActiveToSpeciality < ActiveRecord::Migration[8.0]
  def change
    add_column :specialities, :is_active, :boolean
  end
end
