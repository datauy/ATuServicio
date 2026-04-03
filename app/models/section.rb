class Section < ApplicationRecord

  has_many :indicators
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "is_active", "is_home_card", "name", "period", "description", "title", "updated_at", "weight", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["indicators"]
  end

end
