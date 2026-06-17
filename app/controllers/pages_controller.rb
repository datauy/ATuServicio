class PagesController < ApplicationController
  def index
    @states = [["Todo el país", 0]]
    @states += Zone.where(ztype: "Departamento").order(:name).pluck(:name, :id)
    @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    @providers = Provider.where(active: true).order(:short_name)
    #todo: change max to curent period
    @prices_max = ProviderPrice.includes(:price).group('price.ptype').maximum(:value)
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
end
