class SiteController < ApplicationController
  before_action :get_emergency_id

  def get_emergency_id
    @emergency_id = Datum.find_by(key: 'puerta_urgencia__etiqueta,puertaurge').id
  end
  
  def site_data
    self.summary
    respond_to do |format|
      format.turbo_stream
    end
  end

  def summary
    if params[:id].present?
      @map = false
      if params[:map].present?
        @map = true
        @sites = Site.new.get_map_sites(nil, params[:id])
      end
      @site = Site.find(params[:id])
      @data = SiteDatum.includes(:datum).where(site_id: params[:id], data:{is_active: true})
      if params[:level].present?
        @data = @data.where(level: params[:level])
      end
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def sites
    if params[:name].present?
      @sites = Site.search(params[:name])
    else
      @sites = Site.where(is_active: true)
    end
    if params[:state].present? && params[:state] != '0'
      @sites = @sites.where(state_id: params[:state])
    end
    @page = 0
    if params[:page].present?
      @page = params[:page].to_i
    end
    limit = 10
    offset = @page*limit
    @sites = @sites.offset(offset).order(:name).limit(limit)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def geo_entities
    if params[:name].present?
      @sites = GeoEntity.search(params[:name])
    else
      @sites = GeoEntity.where(is_active: true)
    end
    if params[:state].present? && params[:state] != '0'
      @sites = @sites.where(state_id: params[:state])
    end
    @page = 0
    if params[:page].present?
      @page = params[:page].to_i
    end
    limit = 10
    offset = @page*limit
    @sites = @sites.order(:name).offset(offset).limit(limit)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def provider_state
    if params[:provider].present? && params[:state].present?
      @sites = Site.where(provider_id: params[:provider], state_id: params[:state])
    end
  end
end