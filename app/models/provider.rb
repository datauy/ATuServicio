class Provider < ApplicationRecord

  has_many :provider_datum
  has_many :sites
  has_many :zones, through: :sites
  has_many :states, through: :sites
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

  scope :search , -> (str) { where("LOWER(providers.name) like ? OR LOWER(providers.short_name) like ? " , "%#{str.downcase}%", "%#{str.downcase}%").where(active: true).order(:short_name) }
  
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
        sid: s.id,
        title: s.title,
        description: s.description,
        name: s.name,
        icon: s.name,
        year: s.year,
        period: s.period,
        ctype: 'provider'
      }
      case s.name
      when 'general'
        # general data card
        data = self.provider_datum.where(year: s.year, period: s.period).last
        card['total'] = data.present? && data.total.present? ? data.total : "No hay datos"
        card['fonasa_users'] = data.present? && data.fonasa_users.present? ? data.fonasa_users : "No hay datos"
        card['no_fonasa_users'] = data.present? && data.no_fonasa_users.present? ? data.no_fonasa_users : "No hay datos"
        card['states'] = self.sites.pluck(:state_id).uniq
      when 'rrhh', 'goals'
        card['total'] = {}
        z = Zone.find_by(ztype: "País")
        s.indicators.where(is_active: true).order(:weight).each do |i|
          card['total'][i.abbr] = {
            title: i.title,
            value: self.provider_indicators.where(year: s.year, period: s.period, indicator: i, zone_id: z.id).pluck(:value).first,
            max_value: i.max_value
          }
        end
        #logger.debug " SINDICATRS: #{card['total'].inspect}"
        #return
      when 'prices'
        # prices card
        card['total'] = self.provider_prices.includes(:price).where(year: s.year, period: s.period).group('price.ptype').average(:value)
        card['max'] = @prices_max
      end
      cards.push(card)
    end
    cards
  end
end
