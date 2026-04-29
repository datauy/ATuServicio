class ProviderController < ApplicationController

  def details
    @headers = 1
    p = Provider.find(params[:id])
    if p.present?
      @s = []
      Section.where(is_active: true).order(:weight).each do |s|
        data = []
        case s.name
        when 'general'
          data = p.provider_data.find_by(year: s.year, period: s.period)
        end
        section = s.serializable_hash
        section['data'] = data
        @s.push(section) 
      end
      @providers = [p]
    else
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  end

  def compare
    @headers = 1
    provs = []
    for id in 1..3 do
      provs.push(params[:"id#{id}"]) if params[:"id#{id}"].present?
    end
    @pids = provs
    @providers = Provider.where(id: provs).order(:short_name)
    if @providers.length > 0
      @s = []
      Section.where(is_active: true).order(:weight).each do |s|
        data = []
        @providers.each do |p|
          case s.name
          when 'general'
            datum = p.provider_data.find_by(year: s.year, period: s.period)
          when 'prices'
            datum = {fonasa:{}, no_fonasa: {}}
            p.provider_prices.where(year: s.year, period: s.period).each do |pp|
              if pp.fonasa
                datum[:fonasa][pp.price_id] = pp.value
              else
                datum[:no_fonasa][pp.price_id] = pp.value
              end
            end
          when 'goals', 'rrhh', 'rrhh_cad'
            datum = p.provider_indicators.
            includes(:indicator).
            where('indicator.section_id': s.id, year: s.year, period: s.period).
            pluck(:indicator_id, :value).to_h
          when 'specialists'
            datum = p.provider_specialists.
            where( year: s.year, period: s.period).
            pluck(:speciality_id, :value).to_h
          when 'sites'
            datum = {}
            loc = ''
            p.zones.each do |z|
              zones = z.get_tree
              zsites = z.sites.where(provider_id: p.id)
              zsites.each do |zs|
                site = zs.serializable_hash
                site['zones'] = zones
                site['levels'] = zs.site_data.order(:level).pluck(:level).uniq
                #Add Site
                depto = zones['Departamento'].name
                if datum[depto].present?
                  datum[depto].push(site)
                else
                  datum[depto] = [site]
                end
              end
            end
          end
          data.push(datum)
        end
        section = s.serializable_hash
        section['data'] = data
        @s.push(section)
      end
    end
  end

  def search
    @type = 'summary'
    if params[:name].present?
      @providers = Provider.search(params[:name])
    else
      #TODO: Agregar validación de activo
      @providers = Provider.all
    end
    if params[:type].nil? || params[:type] != 'summary'
      @type = 'list'
      @providers = @providers.pluck(:id, :short_name).to_h
    else
      @sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    end
    respond_to do |format|
      format.turbo_stream
    end
  end

  def get_summary
    @errors = []
    @provider = Provider.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
end
