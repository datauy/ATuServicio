class ProviderIndicator < ApplicationRecord
  belongs_to :provider
  belongs_to :zone
  belongs_to :indicator

end
