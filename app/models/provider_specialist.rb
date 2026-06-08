class ProviderSpecialist < ApplicationRecord
  belongs_to :provider
  belongs_to :speciality
  belongs_to :zone

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "period", "provider_id", "speciality_id", "updated_at", "value", "year", "zone_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "speciality", "zone"]
  end

end
