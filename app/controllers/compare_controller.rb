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
    @rrhh_cad = {}
    @rrhh_general = {}
    IndicatorActive.
    includes(:indicator).
    where(year: @year, stage: @stage, active: true, "indicators.section": ['rrhh_cad', 'rrhh_general']).
    each do |ind|
      if ind.indicator.section == 'rrhh_cad'
        @rrhh_cad[ind.indicator.id] = {desc: ind.indicator.description, key: ind.indicator.key, indicator_values: [] }
      else
        @rrhh_general[ind.indicator.id] = {desc: ind.indicator.description, indicator_values: [] }
      end
      @selected_providers.each do |provider|
        relation = provider.provider_relations.find_by(
          indicator_id: ind.indicator.id,
          state_id: @selected_state,
          year: @year,
          stage: @stage
        )
        # TODO: Mejorar con instance variables, por ahora son 2
        if (ind.indicator.section == 'rrhh_cad')
          if relation.present?
            @rrhh_cad[ind.indicator.id][:indicator_values].push(relation.indicator_value)
          else
            @rrhh_cad[ind.indicator.id][:indicator_values].push(nil)
          end
        end
        if (ind.indicator.section == 'rrhh_general')
          if relation.present?
            @rrhh_general[ind.indicator.id][:indicator_values].push(relation.indicator_value)
          else
            @rrhh_general[ind.indicator.id][:indicator_values].push(nil)
          end
        end
      end
    end
    #get Specialists
    @specialists = {}
    i = 0
    states = []
    @selected_providers.each do |provider|
      states += provider.states.uniq
      processed = []
      provider.
      provider_relations.
      joins(:specialist).
      where("provider_relations.state_id": @selected_state, "provider_relations.year": @year, "provider_relations.stage": @stage).
      order("specialists.title").
      pluck(:"specialists.id", :title, :indicator_value).
      each do |spec|
        if @specialists.key?(spec[0])
          @specialists[spec[0]][:i_vals].push(spec[2])
        else
          ivals = Array.new(i, nil);
          ivals.push(spec[2])
          @specialists[spec[0]] = {
            title: spec[1],
            i_vals: ivals
          }
        end
        processed.push(spec[0])
      end
      # Add nil to specialists values
      not_processed = @specialists.keys - processed
      not_processed.each do |np|
        @specialists[np][:i_vals].push(nil)
      end
      i += 1
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
