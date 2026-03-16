class CreateIndicatorActives < ActiveRecord::Migration[8.0]
  def change
    create_table :indicator_actives do |t|
      t.references :indicator, index: true, foreign_key: true
      t.integer :year
      t.string :period
      t.boolean :active

      t.timestamps null: false
    end
  end
end
