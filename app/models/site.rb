class Site < ApplicationRecord
  belongs_to :zone
  belongs_to :provider
end
