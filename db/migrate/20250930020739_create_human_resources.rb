class CreateHumanResources < ActiveRecord::Migration[8.0]
  def change
    create_table :human_resources do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :zone, null: false, foreign_key: true
      t.references :speciality, null: false, foreign_key: true
      t.decimal :value

      t.timestamps
    end
  end
end
