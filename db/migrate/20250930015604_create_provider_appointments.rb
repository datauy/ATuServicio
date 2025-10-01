class CreateProviderAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :provider_appointments do |t|
      t.references :provider, null: false, foreign_key: true
      t.integer :year
      t.string :period
      t.string :means
      t.string :reminder
      t.string :withdraw
      t.string :communication

      t.timestamps
    end
  end
end
