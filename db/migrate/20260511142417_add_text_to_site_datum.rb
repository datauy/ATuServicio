class AddTextToSiteDatum < ActiveRecord::Migration[8.0]
  def change
    add_column :site_data, :text, :string
  end
end
