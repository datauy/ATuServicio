class CreateProviderGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :provider_goals do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :goal, null: false, foreign_key: true
      t.integer :year
      t.string :period
      t.decimal :value

      t.timestamps
    end
  end
end
