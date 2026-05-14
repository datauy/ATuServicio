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
    @states = []
    country_zone = Zone.find_by(ztype: 'País')
    if @providers.length > 0
      @s = []
      Section.where(is_active: true).order(:weight).each do |s|
        data = []
        @providers.each do |p|
          case s.name
          when 'general'
            datum = p.provider_data.find_by(year: s.year, period: s.period)
            logger.debug("STATES 4 PROVIDER: \n #{p.states.uniq.pluck(:name, :id)}")
            @states.concat( p.states.uniq.pluck(:name, :id) )
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
            where('indicator.section_id': s.id, year: s.year, period: s.period, zone_id: country_zone.id).
            pluck(:indicator_id, :value).to_h
          when 'specialists'
            datum = p.provider_specialists.
            where( year: s.year, period: s.period, zone_id: country_zone.id).
            pluck(:speciality_id, :value).to_h
          when 'sites'
            datum = {}
            loc = ''
            p.zones.each do |z|
              zones = z.parents
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
  #
  def get_state_data
    @providers = params[:providers].split(',')
    zone_id = Zone.find_by(ztype: 'País').id
    if params[:departamento].present?
      zone_id = params[:departamento]
    end
    specSection = Section.find_by(name: 'specialists')
    rrhhSection = Section.find_by(name: 'rrhh')
    specData = {data:[], name: 'specialists'}.stringify_keys
    rrhhData = {data:[], name: 'rrhh', 'id': rrhhSection.id}.stringify_keys 
    Provider.where(id: @providers).order(:short_name).each do |p|
      rrhhData['data'].push(p.provider_indicators.
      includes(:indicator).
      where('indicator.section_id': rrhhSection.id, year: rrhhSection.year, period: rrhhSection.period, zone_id: zone_id).
      pluck(:indicator_id, :value).to_h)
      specData['data'].push(p.provider_specialists.
      where( year: specSection.year, period: specSection.period, zone_id: zone_id).
      pluck(:speciality_id, :value).to_h)
    end
    @sections = [rrhhData, specData]
    respond_to do |format|
      format.turbo_stream
    end
  end
  #
  def search
    @type = 'summary'
    if params[:name].present?
      @providers = Provider.search(params[:name])
    else
      @providers = Provider.where(active: true)
    end
    if params[:departamento].present?
        @providers = @providers.includes(:sites).where("sites.state_id": params[:departamento])
        logger.debug "PROVIDERS SEARCH #{@providers}"
    end
    @providers = @providers.order(:short_name)
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
