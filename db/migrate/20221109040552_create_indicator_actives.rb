class CreateIndicatorActives < ActiveRecord::Migration
  def change
    create_table :indicator_actives do |t|
      t.references :indicator, index: true, foreign_key: true
      t.integer :year
      t.integer :stage
      t.boolean :active

      t.timestamps null: false
    end
  end
end
