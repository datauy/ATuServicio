class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :key
      t.text :description

      t.timestamps null: false
    end
  end
end
