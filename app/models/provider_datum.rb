class ProviderDatum < ApplicationRecord
  belongs_to :provider

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fonasa_users", "id", "no_fonasa_users", "period", "provider_id", "total", "updated_at", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider"]
  end

end
