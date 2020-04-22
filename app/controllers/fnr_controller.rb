# coding: utf-8
class FnrController < ApplicationController
  layout 'atuservicio'

  def index
    @title = 'FNR'
    @description = 'Conocé los tiempos de espera que hay para cualquier operación financiada através del Fondo Nacional de Recursos, así como otros datos útiles.'

    #Waiting time
    @resource = 'dd3046c9-06eb-490e-be95-ba58feb25b5e'
    @interventions = Intervention
      .select("imae_id, count(*) as numb, sum(realizado - autorizado)/count(*) as wait")
      .where.not(realizado: nil)
      .includes(:imae)
      .group(:imae_id)
      .order("wait")
      .map { |i| { qtty: i.wait, groupname: i.imae.nombre, numb: i.numb } }
      .to_json
    @by = if params[:by].nil?
      'intervention_area'
    else
      params[:by]
    end
    Rails.logger.info @interventions.inspect
    @interventions_by = Intervention
      .joins(intervention_type: :intervention_area)
      .select("#{@by}s.id as key, #{@by}s.nombre as groupname, count(*) as qtty")
      .where(realizado: nil)
      .group(:key)
      .order("qtty desc")
      .to_json
      #.map { |i| { count: i.qtty, groupName: i.imae.nombre, averageTime: (i.wait/i.qtty) } }
    #Statistics
    @selected_state = params['departamento']
    # TODO: CACHEAR como en home?
    @providers ||= Provider.select(
      'id',
      'nombre_abreviado'
    ).all
    @states ||= State.all
    @sel_providers = if @selected_state && @selected_state != 'todos'
                       state = State.find_by_name(@selected_state)
                       raise ActionController::RoutingError.new('No se encontró el departamento') unless state
                       state.providers.order(:private_insurance).order(:nombre_abreviado).uniq
                     else
                       @providers.order(:private_insurance).order(:nombre_abreviado)
                     end
    @areas = InterventionArea.all
    # TODO: Filtrar dinámicos los tipos
    @types = InterventionType.all

    respond_to do |format|
      format.js{} #render :template => "fnr/index.js.erb", :layout => false
      format.html{}
    end

  end

  private
  def search_params
    params.permit(:areas, :"intervention-types", :states, :selected_providers, :"stats-areas")
  end

end
