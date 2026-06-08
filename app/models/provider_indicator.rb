class ProviderIndicator < ApplicationRecord
  belongs_to :provider
  belongs_to :zone
  belongs_to :indicator

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "indicator_id", "indicators_id", "period", "provider_id", "updated_at", "value", "year", "zone_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["indicator", "provider", "zone"]
  end

end
