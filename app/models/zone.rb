class Zone < ApplicationRecord
  has_many :sites
  has_many :providers, through: :sites
  belongs_to :parent_zone, class_name: 'Zone', optional: true

  def proper_name
    name.split(StringConstants::SPACE).map(&:capitalize).join(StringConstants::SPACE)
  end

  def to_s
    proper_name
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at", "wkt", "ztype"]
  end

  def parents
    zones = {}
    pz = self.parent_zone
    if pz.present?
      while pz.parent_zone.present?
        zones[pz.ztype] = pz
        pz = pz.parent_zone
      end
      zones[pz.ztype] = pz
    end
    zones
  end

  def state
    pz = self.parent_zone
    while pz.parent_zone.present? && pz.ztype != "Departamento"
      pz = pz.parent_zone
    end
    pz
  end

  def children(depth=1)
    Zone.where(parent_zone: self.id)
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
