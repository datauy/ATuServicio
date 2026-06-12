class RemoveActiveFromProviderIndicator < ActiveRecord::Migration[8.0]
  def change
    remove_column :provider_indicators, :indicators_id, :integer
  end
end
