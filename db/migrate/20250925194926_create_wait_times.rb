class CreateWaitTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :wait_times do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :speciality, null: false, foreign_key: true
      t.integer :wtype
      t.decimal :value
      t.integer :year
      t.string :period

      t.timestamps
    end
  end
end
