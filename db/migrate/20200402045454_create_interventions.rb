class CreateInterventions < ActiveRecord::Migration
  def change
    create_table :interventions do |t|
      t.belongs_to :intervention_area, index: true, foreign_key: true
      t.belongs_to :intervention_type, index: true, foreign_key: true
      t.string :estado
      t.belongs_to :imae, index: true, foreign_key: true
      t.date :solicitado
      t.date :autorizado
      t.date :realizado
      t.integer :edad
      t.string :sexo
      t.belongs_to :state, index: true, foreign_key: true
      t.belongs_to :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
