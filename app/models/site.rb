class Site < ActiveRecord::Base
  belongs_to :provider

  # scope
  def self.providers_by_state(state)
    where(departamento: state).group(:provider_id).count.keys
  end
end
