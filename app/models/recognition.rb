class Recognition < ActiveRecord::Base
  belongs_to :provider
  enum icon: %i[mbp mencion]
end
