class SiteController < ApplicationController
  before_action :get_emergency_id

  def get_emergency_id
    @emergency_id = Datum.find_by(key: 'puerta_urgencia__etiqueta').id
  end
  
  def site_data
    if params[:level].present?
      @data = SiteDatum.where(site_id: params[:id], level: params[:level])
    else
      @data = SiteDatum.where(site_id: params[:id])
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def summary
    if params[:id].present?
      @site = Site.find(params[:id])
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def sites
    if params[:name].present?
      @sites = Site.search(params[:name])
    else
      @sites = Site.where(is_active: true).order(:name)
    end
    if params[:state].present? && params[:state] != '0'
      @sites = @sites.where(state_id: params[:state])
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def geo_entities
    if params[:name].present?
      @sites = GeoEntity.search(params[:name])
    else
      @sites = GeoEntity.where(is_active: true).order(:name)
    end
    if params[:state].present? && params[:state] != '0'
      @sites = @sites.where(state_id: params[:state])
    end
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