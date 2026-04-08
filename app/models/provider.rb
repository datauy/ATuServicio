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
  
  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at", "description", "external_id", "id", "short_name", "updated_at", "web", "active"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["provider_datum", "provider_indicators", "provider_prices", "sites", "specialities", "zones"]
  end

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
    
  def cards(sections)
    cards = []
    sections.each do |s|
      card = {
        title: s.title,
        name: s.name,
        year: s.year,
        period: s.period
      }
      case s.name
      when 'general'
        # general data card
        data = self.provider_datum.where(year: s.year, period: s.period).last
        card['total'] = data.present? && data.total.present? ? data.total : "No hay datos"
        card['fonasa_users'] = data.present? && data.fonasa_users.present? ? data.fonasa_users : "No hay datos"
        card['no_fonasa_users'] = data.present? && data.no_fonasa_users.present? ? data.no_fonasa_users : "No hay datos"

      when 'rrhh'
        card['total'] = {}
        z = Zone.find_by(ztype: "País")
        s.indicators.order(:weight).each do |i|
          card['total'][i.abbr] = {
            title: i.title,
            value: self.provider_indicators.where(year: s.year, period: s.period, indicator: i, zone_id: z.id).pluck(:value).first
          }
        end
        #logger.debug " SINDICATRS: #{card['total'].inspect}"
        #return
      when 'prices'
        # prices card
        card['total'] = self.provider_prices.includes(:price).where(year: s.year, period: s.period).group('price.ptype').sum(:value)
      end
      cards.push(card)
    end
    cards
  end
end
