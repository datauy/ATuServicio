class Price < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at", "ptype"]
  end

  enum :ptype, [
    'medicamentos',
    'tickets',
    'tickets_urgentes',
    'estudios'
  ]

end
