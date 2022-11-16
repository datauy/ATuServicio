class CreateSpecialists < ActiveRecord::Migration
  def change
    create_table :specialists do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
