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

  def get_map_sites(pids=nil)
    sites = {}
    emergency_datum = Datum.find_by(key: 'puerta_urgencia__etiqueta')
    emergency_id = emergency_datum.present? ? emergency_datum.id : 0
    emergency = SiteDatum.where(datum_id: emergency_id, value: 1).pluck(:site_id)
    site_query = Site.
    joins(:zone).
    joins(:site_data).
    joins(:provider).
    includes(:geo_entities).
    select(:id, :name, :description, :address, :provider_id, :stype, :state_id, :wkt, :ztype, :level, "provider.short_name": :pname).
    where(is_active: true)
    if pids.present?
      site_query = site_query.where(provider_id: pids)
    end
    site_query.order(:level).uniq.each do |s|
      #Add site
      if sites[s.id].nil?
        sites[s.id] = s.serializable_hash
      end
      #Add emergency
      sites[s.id]['emergency'] = emergency.include?(s.id) ? true : false
      #Add geo
      if s.geo_entities.present?
        sites[s.id]['geo'] = []
        s.geo_entities.each do |ge|
          sites[s.id]['geo'].push(ge.gtype)
        end
      end
    end
    return sites
  end
end
