class CreateMaximumValues < ActiveRecord::Migration
  def change
    create_table :maximum_values do |t|
      t.decimal :tiempo_espera, precision: 10, scale: 2
      t.decimal :precio_tickets, precision: 10, scale: 2
      t.integer :personal_disponible
      t.timestamps null: false
    end
  end
end
