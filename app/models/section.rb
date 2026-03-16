class Section < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "is_active", "is_home_card", "name", "period", "string", "title", "updated_at", "weight", "year"]
  end

end
