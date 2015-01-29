class Provider < ActiveRecord::Base
  has_many :sites, dependent: :delete_all
end
