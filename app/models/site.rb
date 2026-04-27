class Site < ApplicationRecord
  belongs_to :zone
  belongs_to :provider
  has_many :geo_entities
  has_many :site_data

  enum :stype, [
    "SEDE PRINCIPAL",
    "SEDE SECUNDARIA",
    "POLICLÍNICO",
  ]
end
