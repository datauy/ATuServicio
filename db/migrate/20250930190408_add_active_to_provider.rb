class AddActiveToProvider < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :active, :boolean
  end
end
