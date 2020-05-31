# coding: utf-8
class FnrController < ApplicationController
  layout 'atuservicio'

  def index
    @title = 'FNR'
    @description = 'Conocé los tiempos de espera que hay para cualquier operación financiada através del Fondo Nacional de Recursos, así como otros datos útiles.'
    #filters
    @areas = InterventionArea.all
    #load data
    get_tiempos_de_espera
    #process values for each prestador
    @interventions = @interventions.values.
      each {|res| res[:qtty] = res[:qtty]/res[:numb] }.
      sort_by {|h| h[:qtty]}.
      to_json
    #Process filters
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
    #Stats
    @interventionsource = 'dd3046c9-06eb-490e-be95-ba58feb25b5e'
    get_stats_filters
    query = {}
    if params[:states].present?
      query[:state_id] = params[:states]
    end
    if params[:provider].present?
      query[:provider_fnr_id] = params[:provider]
    end
    if params[:statsArea].present?
      query[:intervention_areas] = {id: params[:statsArea]}
    end

    Rails.logger.info "\n\n\n#{query.inspect}\n\n"

    @interventions_by = Intervention
    .joins(intervention_type: :intervention_area)
    .joins(:imae)
    .select("#{@by}s.id as key, #{@by}s.nombre as groupname, count(*) as qtty")
    .where( query )
    .group(:key)
    .order("qtty desc")
    .to_json

    respond_to do |format|
      format.js{} #render :template => "fnr/index.js.erb", :layout => false
      format.html{}
    end

  end

  private
  def search_params
    params.permit(:areas, :"intervention-types", :states, :selected_providers, :"stats-areas")
  end

  def get_tiempos_de_espera
    #Waiting time
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
    Rails.logger.info "\n #{catalog_url} \n"
    uri = URI(URI.escape(catalog_url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    resp = http.get(uri.request_uri)
    if resp.is_a?(Net::HTTPSuccess)
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
      (JSON.parse resp.body)['result']['records'].each do |pres|
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
    else
      @interventions = 0
    end
  end

  def get_stats_filters
    #filters
    @states ||= State.
      select('id', 'name').
      all.
      map { |p| [p.name, p.id] }
    @by = if params[:by].blank?
        'intervention_area'
      else
        params[:by]
      end
    #In case we filter by area we must show area types since area would be only one
    if params[:statsArea].present? && @by == 'intervention_area'
      @by = 'intervention_type'
    end
    @selected_state = params[:state]
    # TODO: CACHEAR como en home?
    @sel_providers = if params[:state].present?
      ProviderFnr.
        select('id', 'nombre').
        where(state_id: params[:state])
    else
      ProviderFnr.
        select('id', 'nombre').
        all
    end
    @sel_providers = @sel_providers.
      order(:nombre).
      map { |p| [p.nombre, p.id] }
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
