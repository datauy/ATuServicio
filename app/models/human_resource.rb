class HumanResource < ApplicationRecord
  belongs_to :provider
  belongs_to :zone
  belongs_to :speciality

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "provider_id", "speciality_id", "updated_at", "value", "zone_id", "period", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "speciality", "zone"]
  end

end
