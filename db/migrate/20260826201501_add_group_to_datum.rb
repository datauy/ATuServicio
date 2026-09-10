class AddGroupToDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :data, :group, :integer
  end
end
