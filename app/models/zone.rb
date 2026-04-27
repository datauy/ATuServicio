class Zone < ApplicationRecord
  has_many :sites
  has_many :providers, through: :sites

  def proper_name
    name.split(StringConstants::SPACE).map(&:capitalize).join(StringConstants::SPACE)
  end

  def to_s
    proper_name
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at", "wkt", "ztype"]
  end

  # The sites should have coordinates, since zones shuld be polygons
  enum :ztype, [
    "País",
    "Departamento",
    "Localidad",
    'Municipio',
    'Barrio',
    'Zona',
    'Punto'
  ]

  scope :search , -> (str, ztype) { where(ztype: ztype).where("LOWER(name) like ? " , "%#{str.downcase}%").order(:name) }
end
