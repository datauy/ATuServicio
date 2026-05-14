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

  def level
    self.site_data.order(:level).pluck(:level)
  end
end
