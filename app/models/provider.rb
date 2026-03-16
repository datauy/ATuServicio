class Provider < ApplicationRecord

  has_many :provider_datum
  has_many :sites
  has_many :zones, through: :sites
  has_many :indicators
  has_many :specialities

  def asse?
    nombre_abreviado.include?('ASSE')
  end

  # What coverage type exists by state
  def coverage_by_state(state, type)
    sites.where(state: state, nivel: type).count
  end

  def sites_by_state(state)
    sites.where(departamento: state.proper_name).order(localidad: :asc)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at", "description", "external_id", "id", "short_name", "updated_at", "web"]
  end

end
