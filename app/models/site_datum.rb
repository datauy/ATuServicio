class SiteDatum < ApplicationRecord
  belongs_to :datum, optional: true
  belongs_to :site

  enum :level, [
    "Primer nivel de atención",
    "Segundo nivel de atención",
    "Tercer nivel de atención",
  ]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "datum_id", "id", "id_value", "level", "period", "site_id", "text", "updated_at", "value", "year"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["datum", "site"]
  end
end
