class SiteController < ApplicationController

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
    if ( params[:name].present? )
      @sites = Site.search(params[:name])
    else
      @sites = Site.where(is_active: true).order(:name)
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def geo_entities
    if ( params[:name].present? )
      @sites = GeoEntity.search(params[:name])
    else
      @sites = GeoEntity.where(is_active: true).order(:name)
    end
    respond_to do |format|
      format.turbo_stream
    end
  end
end