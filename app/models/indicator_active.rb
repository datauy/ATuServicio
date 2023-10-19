class IndicatorActive < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :specialist
end
