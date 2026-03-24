class ProviderIndicator < ApplicationRecord
  belongs_to :provider
  has_one :zone
  belongs_to :indicator

end
