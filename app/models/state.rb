class State < ActiveRecord::Base
  has_many :provider_state_infos
  has_many :providers, through: :provider_state_infos
end
