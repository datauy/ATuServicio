class CreateInterventionTypes < ActiveRecord::Migration
  def change
    create_table :intervention_types do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
