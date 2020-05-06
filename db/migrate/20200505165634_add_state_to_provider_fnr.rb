class AddStateToProviderFnr < ActiveRecord::Migration
  def change
    add_reference :provider_fnrs, :state, index: true, foreign_key: true
  end
end
