class AddInterventionAreaToInterventionType < ActiveRecord::Migration
  def change
    add_reference :intervention_types, :intervention_area, index: true, foreign_key: true
  end
end
