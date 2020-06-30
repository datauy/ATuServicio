# coding: utf-8
class FnrController < ApplicationController
  layout 'atuservicio'
  protect_from_forgery except: [:test, :teste]

  def test
    logger.info { "\n PASA POR TEST \n" }
    teste
  end

  def waiting
    logger.info { "\n PASA POR TESTE \n" }
    @resource = 'e19133eb-bb6b-467d-9f4b-5c208ed95889'
    catalog_url = "https://catalogodatos.gub.uy/api/3/action/datastore_search?resource_id=#{@resource}&limit=2000"
    query = {}
    if params[:area].present?
      query[:areaid] = params[:area]
    end
    if params[:type].present?
      query[:prestacionid] = params[:type]
    end
    if (!query.empty?)
      catalog_url += "&filters=#{query.to_json}"
    end
    logger.info "\n #{catalog_url} \n"
    uri = URI(URI.escape(catalog_url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    resp = http.get(uri.request_uri)
    if resp.is_a?(Net::HTTPSuccess)
      @resp = resp.body
      logger.info { "\nOK DE CATALOGO\n" }
      process_waiting_data
      process_waiting_filters
    else
      logger.info { "\nERROR DE CATALOGO\n" }
      @interventions = 0
    end
    respond_to do |format|
      format.js{} #render :template => "fnr/index.js.erb", :layout => false
      format.html{}
    end
  end

  def stats
    logger.info { "\n\n TARGET:  #{params[:target]}\n\n" }
    @areas = InterventionArea.all
    @interventionsource = 'dd3046c9-06eb-490e-be95-ba58feb25b5e'
    @query = {}
    @sel_state = nil
    if params[:state_pa].present?
      @query[:state_id] = params[:state_pa]
    end
    if params[:provider].present?
      @query[:provider_fnr_id] = params[:provider]
    end
    if params[:statsArea].present?
      @query[:intervention_areas] = {id: params[:statsArea]}
    end
    if params[:statsKind].present?
      @query[:intervention_kind] = Intervention.intervention_kinds[:"#{params[:statsKind]}"]
    end
    if params[:states].present?
      @query[:provider_fnrs] = { state_id: params[:states] }
    end

    @interventions_by = Intervention
    .joins(intervention_type: :intervention_area)
    .joins(:provider_fnr)
    .joins(:imae)
    .where( @query )
    #Get filters with query unexecuted to get unique filters
    get_stats_filters
    #Parse results to json
    @interventions_by = @interventions_by
      .select("#{@by}s.id as key, #{@by}s.nombre as groupname, count(*) as qtty")
      .group(:key)
      .order("qtty desc")
      .to_json

    logger.info { "\n\n----------  RESULTADO  -------------> : #{@interventions_by}\n\n" }
    respond_to do |format|
      format.js{}
      format.html{}
    end
  end

  def index
    @title = 'FNR'
    @description = 'Conocé los tiempos de espera que hay para cualquier operación financiada através del Fondo Nacional de Recursos, así como otros datos útiles.'
    #Load Catalog Waiting time
    waiting
    #Stats
    stats
  end

  private
  def search_params
    params.permit(:areas, :"intervention-types", :states, :selected_providers, :"stats-areas")
  end

  def get_stats_filters
    #Tipos de intervenciones
    @kinds = Intervention.intervention_kinds.keys
    #Departamentos
    states = State
    if params[:provider].present?
      states = states
        .where( id: ProviderFnr
          .where(id: params[:provider].to_i)
          .pluck(:state_id)
        )
      @sel_state = states.dup.first.id
    end
    @states = states
      .select('id', 'name')
      .all
      .map { |p| [p.name.capitalize(), p.id] }

    @states_pa = State
      .select('id', 'name')
      .all
      .map { |p| [p.name.capitalize(), p.id] }

    @by = if params[:by].blank?
        'intervention_area'
      else
        params[:by]
      end
    #In case we filter by area we must show area types since area would be only one
    if params[:statsArea].present? && @by == 'intervention_area'
      @by = 'intervention_type'
    end
    #Providers
    @providers = if params[:states].present?
      @sel_state = params[:states]
      provider_ids = if params[:target] != 'provider'
        @interventions_by
          .dup
          .uniq
          .pluck(:provider_fnr_id)
      else
        Intervention
          .joins(intervention_type: :intervention_area)
          .joins(:provider_fnr)
          .where( @query.except(:provider) )
          .uniq
          .pluck(:provider_fnr_id)
      end
      if provider_ids.present?
        ProviderFnr
          .select('id', 'nombre')
          .where(id: provider_ids)
      else
        ProviderFnr.select('id', 'nombre').all
      end
    else
      ProviderFnr.select('id', 'nombre').all
    end
    # TODO: CACHEAR como en home?
    @providers = @providers
      .order(:nombre)
      .map { |p| [p.nombre, p.id] }
  end
  #Process filters from response
  def process_waiting_filters
    @waiting_areas = @waiting_filters.map{ |k,a| [a[:nombre], a[:id]] }
    @types = []
    if params[:area].present?
      area = params[:area].to_s
      logger.info { "\nWTF\n" }
      @waiting_filters[area][:types].each do |k,t|
        @types << [t[:nombre], t[:id]]
      end
    else
      logger.info { "\nWTF2\n" }
      @waiting_filters.each do |k,a|
        a[:types].each do |k,t|
          @types << [t[:nombre], t[:id]]
        end
      end
    end
  end

  #Process data from catalog
  def process_waiting_data
    first = false
    @interventions = {}
    if session[:fnr_waiting].blank?
      logger.info { "\n\nPASA POR FILTER\n\n" }
      @waiting_filters = {}
      first = true
    else
      logger.info { "\n\nNO PASA POR FILTER\n\n" }
      @waiting_filters = JSON.parse(session[:fnr_waiting]).with_indifferent_access
    end
    (JSON.parse @resp)['result']['records'].each do |pres|
      imae_id = pres["imaeid"]
      area_id = pres["areaid"]
      presta_id = pres["prestacionid"]
      if @interventions[imae_id].nil?
        @interventions[imae_id] = {
          id: imae_id,
          qtty: (pres['fecharealizacion'].to_date - pres['fechaautorizacion'].to_date).to_i,
          groupname: pres["imaenombre"],
          numb: 1
        }
      else
        @interventions[imae_id][:numb] += 1
        @interventions[imae_id][:qtty] += (pres['fecharealizacion'].to_date - pres['fechaautorizacion'].to_date).to_i
      end
      if first
        if @waiting_filters[area_id].nil?
          @waiting_filters[area_id] = {id: pres["areaid"], nombre: pres["areanombre"], types: {} }
        end
        if @waiting_filters[area_id][:types][presta_id].nil?
          @waiting_filters[area_id][:types][presta_id] = {id: pres["prestacionid"], nombre: pres["prestacionnombre"]}
        end
      end
    end
    Rails.logger.info "\n #{@waiting_filters.inspect} \n"
    session[:fnr_waiting] = @waiting_filters.to_json if first
    #process values for each prestador
    @interventions = @interventions.values.
      each {|res| res[:qtty] = res[:qtty]/res[:numb] }.
      sort_by {|h| h[:qtty]}.
      to_json
  end
end

=begin
Query para datos de tiempos de espera en base
@interventions = Intervention
  .select("imae_id, count(*) as numb, sum(realizado - autorizado)/count(*) as wait")
  .where.not(realizado: nil)
  .includes(:imae)
  .group(:imae_id)
  .order("wait")
  .map { |i| { qtty: i.wait, groupname: i.imae.nombre, numb: i.numb } }
  .to_json
=end
