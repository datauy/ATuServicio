class AddKindToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :intervention_kind, :integer
  end
end
