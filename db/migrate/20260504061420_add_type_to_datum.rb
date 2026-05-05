class AddTypeToDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :data, :dtype, :integer
  end
end
