class ProviderAppointment < ApplicationRecord
  belongs_to :provider

  def self.ransackable_attributes(auth_object = nil)
    ["communication", "created_at", "id", "means", "period", "provider_id", "reminder", "updated_at", "withdraw", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider"]
  end

end
