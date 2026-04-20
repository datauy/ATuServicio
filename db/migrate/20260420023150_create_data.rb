class CreateData < ActiveRecord::Migration[8.0]
  def change
    create_table :data do |t|
      t.string :title
      t.text :description
      t.string :key
      t.boolean :is_active

      t.timestamps
    end
  end
end
