class Speciality < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["abbr", "created_at", "id", "name", "updated_at"]
  end

end
