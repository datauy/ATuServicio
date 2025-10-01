class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers do |t|
      t.integer :external_id
      t.string :short_name
      t.string :name
      t.string :web
      t.text :description

      t.timestamps
    end
  end
end
