class ProviderSpecialist < ApplicationRecord
  belongs_to :provider
  belongs_to :speciality
  belongs_to :zone

end
