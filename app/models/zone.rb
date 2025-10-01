class Zone < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at", "wkt", "ztype"]
  end

end
