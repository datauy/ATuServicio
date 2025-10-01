class ProviderGoal < ApplicationRecord
  belongs_to :provider
  belongs_to :goal

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "goal_id", "id", "period", "provider_id", "updated_at", "value", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["goal", "provider"]
  end

end
