class Intervention < ActiveRecord::Base
  belongs_to :intervention_area
  belongs_to :intervention_type
  belongs_to :imae
  belongs_to :state
  belongs_to :provider_fnr

  enum intervention_kind: ['Acto Médico', 'Tratamiento con medicamentos', 'Otra Prestación']
end
