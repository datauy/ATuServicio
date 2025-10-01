class CreateSpecialities < ActiveRecord::Migration[8.0]
  def change
    create_table :specialities do |t|
      t.string :name
      t.string :abbr

      t.timestamps
    end
  end
end
