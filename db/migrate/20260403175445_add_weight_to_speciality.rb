class AddWeightToSpeciality < ActiveRecord::Migration[8.0]
  def change
    add_column :specialities, :weight, :integer
  end
end
