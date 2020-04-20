class CreateProviderFnrs < ActiveRecord::Migration
  def change
    create_table :provider_fnrs do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
