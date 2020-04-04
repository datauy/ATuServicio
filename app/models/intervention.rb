class Intervention < ActiveRecord::Base
  belongs_to :intervention_area
  belongs_to :intervention_type
  belongs_to :imae
  belongs_to :state
  belongs_to :provider
end
