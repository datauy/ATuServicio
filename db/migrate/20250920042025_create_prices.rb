class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.string :name

      t.timestamps
    end
  end
end
