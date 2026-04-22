class PagesController < ApplicationController
  def index
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    @geodata = GeoEntity.joins(:zone).select(:id, :name, :description, :site_id, :wkt, :ztype, :gtype).where(is_active: true)
  end

  def about

  end

  def affiliations

  end

  def inqueries

  end
end
