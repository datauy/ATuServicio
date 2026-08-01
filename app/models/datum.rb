class Datum < ApplicationRecord

  enum :dtype, [
    "value",
    "boolean",
    "array",
  ]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "dtype", "id", "id_value", "is_active", "key", "title", "updated_at"]
  end

  def search_key(key)
    self.where("key contains ?", "%#{key}%").first
  end
end
