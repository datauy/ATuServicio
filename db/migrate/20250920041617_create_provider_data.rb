class CreateProviderData < ActiveRecord::Migration[8.0]
  def change
    create_table :provider_data do |t|
      t.integer :year
      t.string :period
      t.integer :fonasa_users
      t.integer :no_fonasa_users
      t.integer :total
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
