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
end