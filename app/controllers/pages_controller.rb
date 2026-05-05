class PagesController < ApplicationController
  def index
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    @geodata = GeoEntity.joins(:zone).select(:id, :name, :description, :site_id, :wkt, :ztype, :gtype).where(is_active: true)
    @sites = {}
    Site.
    joins(:zone).
    joins(:site_data).
    includes(:geo_entities).
    select(:id, :name, :description, :address, :provider_id, :stype, :wkt, :ztype, :stype, :level).
    order(:level).all.each do |s|
      if @sites[s.id].nil?
        @sites[s.id] = s.serializable_hash
      end
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
