class ProviderPrice < ApplicationRecord
  belongs_to :provider
  belongs_to :price

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fonasa", "id", "value", "price_id", "provider_id", "updated_at", "period", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["price", "provider"]
  end

end
