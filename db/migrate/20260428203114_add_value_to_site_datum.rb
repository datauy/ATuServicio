class AddValueToSiteDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :site_data, :value, :decimal
  end
end
