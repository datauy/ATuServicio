class CreateIndicators < ActiveRecord::Migration[8.0]
  def change
    create_table :indicators do |t|
      t.string :key
      t.text :description

      t.timestamps
    end
  end
end
