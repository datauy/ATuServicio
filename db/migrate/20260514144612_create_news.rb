class CreateNews < ActiveRecord::Migration[8.0]
  def change
    create_table :news do |t|
      t.string :head
      t.string :title
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
