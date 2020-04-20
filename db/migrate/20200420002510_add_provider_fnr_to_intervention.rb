class AddProviderFnrToIntervention < ActiveRecord::Migration
  def change
    add_reference :interventions, :provider_fnr, index: true, foreign_key: true
  end
end
