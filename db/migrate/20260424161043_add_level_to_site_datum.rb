class AddLevelToSiteDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :site_data, :level, :integer
  end
end
