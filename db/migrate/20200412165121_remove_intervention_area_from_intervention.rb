class RemoveInterventionAreaFromIntervention < ActiveRecord::Migration
  def change
    remove_reference :interventions, :intervention_area, index: true, foreign_key: true
  end
end
