# coding: utf-8
class FnrController < ApplicationController
  layout 'atuservicio'

  def index
    @title = 'FNR'
    @description = 'Conocé los tiempos de espera que hay para cualquier operación financiada através del Fondo Nacional de Recursos, así como otros datos útiles.'
    #Waiting time
    @resource = 'dd3046c9-06eb-490e-be95-ba58feb25b5e'
    #filters
    @areas = InterventionArea.all
    @types =
      if params[:area].present?
        @area_name = InterventionArea.find_by(id: params[:area]).nombre
        InterventionType.where(intervention_area_id: params[:area])
      else
        InterventionType.all
      end
    #data
    get_tiempos_de_espera
    @interventions = @interventions.values.
      each {|res| res[:qtty] = res[:qtty]/res[:numb] }.
      sort_by {|h| h[:qtty]}.
      to_json

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
    catalog_url = 'https://catalogodatos.gub.uy/api/3/action/datastore_search?resource_id=dd3046c9-06eb-490e-be95-ba58feb25b5e&limit=200'
    query = {}
    if @area_name.present?
      query[:area_prestacion] = @area_name
    end
    if params[:type].present?
      query[:prestacion_desc] = InterventionType.find_by(id: params[:type]).nombre
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
      @interventions = {}
      (JSON.parse resp.body)['result']['records'].each do |pres|
        imae_id = pres["IMAE/Clinica/Centro_cod"]
        if @interventions[imae_id].nil? #imaeId
          @interventions[imae_id] = {
            qtty: (pres['fecha_solicitud'].to_date - pres['fecha_autorizacion'].to_date).to_i.abs, #fechaRealizacion - fechaAutorizacion # TODO: Quitar el abs
            groupname: pres["IMAE/Clinica/Centro"], #imaeNombre
            numb: 1
          }
        else
          @interventions[imae_id][:numb] += 1
          @interventions[imae_id][:qtty] += (pres['fecha_solicitud'].to_date - pres['fecha_autorizacion'].to_date).to_i.abs
        end
      end
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
