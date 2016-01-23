class CreateState < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, unique: true, null: false
      t.timestamps null: false
    end
    change_table :sites do |t|
      t.references :states
    end
  end
end
