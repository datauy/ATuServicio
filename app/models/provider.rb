class Provider < ApplicationRecord

  has_many :provider_datum
  has_many :sites
  has_many :zones, through: :sites
  has_many :provider_indicators
  has_many :indicators, through: :provider_indicators
  has_many :provider_specialists
  has_many :specialities, through: :provider_specialists
  has_many :provider_prices
  has_many :provider_data
  
  has_one_attached :logo
  
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
    ["name", "created_at", "description", "external_id", "id", "short_name", "updated_at", "web", "active"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider_datum", "provider_indicators", "provider_prices", "sites", "specialities", "zones"]
  end

end
