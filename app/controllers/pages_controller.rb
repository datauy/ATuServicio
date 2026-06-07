class PagesController < ApplicationController
  def index
    @states = [["Todo el país", 0]]
    @states += Zone.where(ztype: "Departamento").order(:name).pluck(:name, :id)
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    #todo: change max to curent period
    @prices_max = ProviderPrice.includes(:price).group('price.ptype').maximum(:value)
    @geodata = GeoEntity.joins(:zone).select(:id, :name, :description, :site_id, :wkt, :ztype, :gtype).where(is_active: true)
    @sites = {}
    emergency_datum = Datum.find_by(key: 'puerta_urgencia__etiqueta')
    emergency_id = emergency_datum.present? ? emergency_datum.id : 0
    emergency = SiteDatum.where(datum_id: emergency_id, value: 1).pluck(:site_id)
    Site.
    joins(:zone).
    joins(:site_data).
    joins(:provider).
    includes(:geo_entities).
    select(:id, :name, :description, :address, :provider_id, :stype, :wkt, :ztype, :level, "provider.short_name": :pname).
    where(is_active: true).
    order(:level).uniq.each do |s|
      #Add site
      if @sites[s.id].nil?
        @sites[s.id] = s.serializable_hash
      end
      #Add emergency
      @sites[s.id]['emergency'] = emergency.include?(s.id) ? true : false
      #Add geo
      if s.geo_entities.present?
        @sites[s.id]['geo'] = []
        s.geo_entities.each do |ge|
          @sites[s.id]['geo'].push(ge.gtype)
        end
      end
    end
    @news = News.where(is_active: true).order(:created_at).limit(3)
  end

  def about

  end

  def affiliations

  end

  def inqueries

  end
end
