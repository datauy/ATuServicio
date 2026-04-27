class CreateSiteData < ActiveRecord::Migration[8.0]
  def change
    create_table :site_data do |t|
      t.references :datum, foreign_key: true
      t.references :site, null: false, foreign_key: true
      t.integer :year
      t.string :period

      t.timestamps
    end
  end
end
