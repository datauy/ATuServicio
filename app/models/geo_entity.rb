class GeoEntity < ApplicationRecord
  belongs_to :zone
  belongs_to :site, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "gtype", "id", "name", "updated_at", "zone_id", "is_active", "site_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["zone", "site"]
  end

  scope :search , -> (str) { where(is_active: true).where("LOWER(name) like ? " , "%#{str.downcase}%").order(:name) }
  
end
