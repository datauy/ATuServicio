class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string :title
      t.string :name
      t.string :description
      t.integer :year
      t.string :period
      t.boolean :is_home_card

      t.timestamps
    end
  end
end
