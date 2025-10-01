class Provider < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at", "description", "external_id", "id", "short_name", "updated_at", "web"]
  end

end
