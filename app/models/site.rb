class Site < ApplicationRecord
  belongs_to :zone
  belongs_to :provider
  belongs_to :state, class_name: 'Zone'
  has_many :geo_entities
  has_many :site_data

  enum :stype, [
    "SEDE PRINCIPAL",
    "SEDE SECUNDARIA",
    "POLICLÍNICO",
  ]

  scope :search , -> (str) { where(is_active: true).where("LOWER(name) like ? " , "%#{str.downcase}%").order(:name) }

  def levels
    self.site_data.order(:level).pluck(:level)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "address_comp", "created_at", "description", "email", "highway", "highway_km", "id", "id_value", "is_active", "name", "phone", "provider_id", "state_id", "stype", "updated_at", "web", "zone_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["geo_entities", "provider", "site_data", "state", "zone"]
  end
end
