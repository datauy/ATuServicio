# coding: utf-8
class CompareController < ApplicationController
  layout 'atuservicio'

  def index
    unless params[:selected_providers]
      flash['alert'] = "Debe elegir al menos un proveedor para ver los datos de comparación"
      redirect_to '/'
      return
    end

    provider_ids = params[:selected_providers].try(:split, ' ').try(:uniq) || []
    flash['alert'] = 'Solo se pueden elegir hasta 3 proveedores' if provider_ids.length > 3

    @selected_providers = Provider.
      where(id: provider_ids.take(3)).
      includes([:sites, :states])
      #includes(:recognitions)
    # TODO: @available_states
    raise ActionController::RoutingError.new('Proveedor no encontrado') if @selected_providers.empty?

    @title = 'Comparando'

    @description = 'Compará éstos prestadores de Salud para elegir informado o personalizalo para conocer a fondo los indicadores del tuyo.'

    @groups = {
      estructura: 'estructura',
      tiempos_espera: 'calendar',
      satisfaccion_derechos: 'derechos',
      precios: 'price',
      metas: 'metas',
      rrhh: 'rrhh',
      rrhh_cad: 'rrhh_cad',
      rrhh_especialistas: 'rrhh_especialistas',
      solicitud_consultas: 'consultas'
    }
    @selected_state = params['departamento'] && params['departamento'] != 'todos' ? State.find_by_name(params['departamento']).id : nil
    #Get indicators
    @indicators = {}
    IndicatorActive.
    includes(:indicator).
    where(active: true).
    order(:updated_at).
    each do |ind|
      if @indicators[:"#{ind.indicator.section}"].present?
        @indicators[:"#{ind.indicator.section}"][ind.indicator.id] = {desc: ind.indicator.description, key: ind.indicator.key, indicator_values: [] }
      else
        @indicators[:"#{ind.indicator.section}"] = { ind.indicator.id: {desc: ind.indicator.description, key: ind.indicator.key, indicator_values: [] } }
      end
      @selected_providers.each do |provider|
        relation = provider.provider_relations.find_by(
          indicator_id: ind.indicator.id,
          state_id: @selected_state,
          year: ind.year,
          stage: ind.stage
        )
        if relation.present?
          @indicators[:"#{ind.indicator.section}"][ind.indicator.id][:indicator_values].push(relation.indicator_value)
        else
          @indicators[:"#{ind.indicator.section}"][ind.indicator.id][:indicator_values].push(nil)
        end
      end
    end
    #get Specialists
    @specialists = {}
    states = []
    IndicatorActive.
    includes(:specialist).
    where(active: true).
    each do |iaSpec|
      @specialists[iaSpec.specialist.id] = {
        title: iaSpec.specialist.title,
        i_vals: []
      }
      @selected_providers.each do |provider|
        states += provider.states.uniq
        relation = provider.provider_relations.find_by(
          specialist_id: iaSpec.specialist.id,
          state_id: @selected_state,
          year: iaSpec.year,
          stage: iaSpec.stage
        )
        if relation.present?
          @specialists[iaSpec.specialist.id][:i_vals].push(relation.indicator_value)
        else
          @specialists[iaSpec.specialist.id][:i_vals].push(nil)
        end
      end
    end
    @active_states = states.uniq
    #Rails.logger.debug { "\nACCCCCCCCCCCCCCAAAAAAAAAAAAAAAAAAAAAAAAA\n#{@specialists.inspect}\n\n" }
    #
    respond_to do |format|
      format.js{
        render :template => "compare/index.js.erb", :layout => false
      }
      format.html{}
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def add
    selected_providers = "#{params[:selected_providers]} #{params[:provider_id]}".split(' ').uniq.join(' ')
    redirect_to action: 'index', selected_providers: selected_providers
  end
end
