class Indicator < ActiveRecord::Base
  has_many :provider_relations
  has_many :states, through: :provider_relations
  has_many :indicator_actives

scope :rrhh_cad, ->(year) { where(section: 'rrhh_cad').joins(:indicator_actives).where("indicator_actives.active = true and indicator_actives.year = #{year}") }

scope :rrhh_general, ->() { where(section: 'rrhh_general') }

end
