class WaitTime < ApplicationRecord
  belongs_to :provider
  belongs_to :speciality

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "period", "provider_id", "speciality_id", "updated_at", "value", "wtype", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "speciality"]
  end

end
