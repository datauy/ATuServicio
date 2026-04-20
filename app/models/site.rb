class Site < ApplicationRecord
  belongs_to :zone
  belongs_to :provider
  has_many :geo_entities
end
