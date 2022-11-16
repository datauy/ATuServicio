class ProviderRelation < ActiveRecord::Base
  belongs_to :provider
  belongs_to :specialist
  belongs_to :indicator
  belongs_to :state
end
