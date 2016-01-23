class CreateState < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, unique: true, null: false
      t.timestamps null: false
    end
  end
end
