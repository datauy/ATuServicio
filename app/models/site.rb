class Site < ActiveRecord::Base
  belongs_to :provider

  # scope
  def self.providers_by_state(state)
    departamento = state.split("_").map(&:capitalize).join(" ")
    where(departamento: departamento).group(:provider_id).count.keys
  end
end
