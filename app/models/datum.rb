class Datum < ApplicationRecord

  has_one_attached :icon

  enum :dtype, [
    "value",
    "boolean",
    "array",
  ]
  enum :group, [
    "Información general",
    "Equipamiento"
  ]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "dtype", "id", "id_value", "is_active", "key", "title", "updated_at"]
  end

  def search_key(key)
    self.where("key contains ?", "%#{key}%").first
  end
end
