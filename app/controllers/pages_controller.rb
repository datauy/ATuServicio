class PagesController < ApplicationController
  def index
    @states = [["Todo el país", 0]]
    @states += Zone.where(ztype: "Departamento").order(:name).pluck(:name, :id)
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    #todo: change max to curent period
    @prices_max = {}
    s = Section.find_by(name: "prices")
    @prices_max['Ticket general de medicamentos'] = ProviderPrice.includes(:price).where(year: s.year, period: s.period, fonasa: true, "price.name": "Ticket de medicamentos - general").pluck(:value).max
    @prices_max['Consulta no urgente consultorio – Médico General'] = ProviderPrice.includes(:price).where(year: s.year, period: s.period, fonasa: true, "price.name": "Consulta no urgente consultorio: medicina general").pluck(:value).max
    @prices_max['Consulta no urgente consultorio – Especialista'] = ProviderPrice.includes(:price).where(year: s.year, period: s.period, fonasa: true, "price.name": "Consulta no urgente consultorio: otras especialidades").pluck(:value).max
    @prices_max['Consulta Urgencia Centralizada (Puerta)'] = ProviderPrice.includes(:price).where(year: s.year, period: s.period, fonasa: true, "price.name": "Consulta urgencia centralizada").pluck(:value).max
    @prices_max['Estudios (promedio de los precios FONASA)'] = ProviderPrice.includes(:price).where(year: s.year, period: s.period, fonasa: true, "price.ptype": "estudios").group(:provider_id).average(:value).values.max
    @geodata = GeoEntity.joins(:zone).select(:id, :name, :description, :site_id, :wkt, :ztype, :gtype).where(is_active: true)
    @sites = Site.new.get_map_sites()
    @news = News.where(is_active: true).order(:created_at).limit(3)
  end

  def about

  end

  def affiliations

  end

  def inqueries

  end

  def benefits

  end

  def pias

  end
  
  def info
    
  end
end
