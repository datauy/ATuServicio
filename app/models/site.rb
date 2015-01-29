class Site < ActiveRecord::Base
  belongs_to :provider

  # scope
  def self.by_state(state)
    where(departamento: 'Montevideo').group(:provider_id).count.keys
  end
end
