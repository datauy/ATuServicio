class ProviderStateInfo < ActiveRecord::Base
  belongs_to :provider
  belongs_to :state
end
