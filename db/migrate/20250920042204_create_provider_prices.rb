class CreateProviderPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :provider_prices do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :price, null: false, foreign_key: true
      t.boolean :fonasa
      t.integer :value
      t.integer :year
      t.string :period

      t.timestamps
    end
  end
end
