class SiteEquipment < ApplicationRecord
  belongs_to :site
  belongs_to :equipment
end
