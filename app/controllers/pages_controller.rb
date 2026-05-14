class PagesController < ApplicationController
  def index
    @states = Zone.where(ztype: "Departamento").order(:name).pluck(:name, :id)
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    @geodata = GeoEntity.joins(:zone).select(:id, :name, :description, :site_id, :wkt, :ztype, :gtype).where(is_active: true)
    @sites = {}
    emergency_id = Datum.where(key: 'puerta_urgencia__etiqueta')
    emergency = SiteDatum.where(datum_id:8, value: 1).pluck(:site_id)
    Site.
    joins(:zone).
    joins(:site_data).
    joins(:provider).
    includes(:geo_entities).
    select(:id, :name, :description, :address, :provider_id, :"providers.name", :stype, :wkt, :ztype, :stype, :level).
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
  end

  def about

  end

  def affiliations

  end

  def inqueries

  end
end
