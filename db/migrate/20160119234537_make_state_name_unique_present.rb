class MakeStateNameUniquePresent < ActiveRecord::Migration
  def change
    change_column :states, :name, :string, unique: true, null: false
  end
end
