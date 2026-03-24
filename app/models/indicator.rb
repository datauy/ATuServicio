class Indicator < ApplicationRecord
  belongs_to :section

  def self.ransackable_attributes(auth_object = nil)
    ["abbr", "active", "created_at", "description", "id", "id_value", "is_active", "key", "section", "section_id", "title", "updated_at", "weight"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["section"]
  end
end
