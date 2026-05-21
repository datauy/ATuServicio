class News < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "head", "id", "id_value", "is_active", "link", "title", "updated_at"]
  end
  
end
