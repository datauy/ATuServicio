# coding: utf-8
class HomeController < ApplicationController
  layout 'atuservicio'

  def index
    # Get the ProviderMaximum object which contains all the maximum
    # values to compare in the graphs in the home view.
    @provider_maximums = ProviderMaximum.first

    @title = 'Inicio'
    @description = 'Toda la información e indicadores de todos los prestadores de Salud de Uruguay para elegir informado o conocer a fondo los indicadores de tu servicio de salud.'

    # Get the selected state if we want to have the providers for a
    # given state
    @selected_state = params['departamento']

    @sel_providers = if @selected_state && @selected_state != 'todos'
                       state = State.find_by_name(@selected_state)
                       raise ActionController::RoutingError.new('No se encontró el departamento') unless state
                       state.providers.includes(:states).order(:private_insurance).order(:nombre_abreviado).uniq
                     else
                       @providers.order(:private_insurance).order(:nombre_abreviado)
                     end
  end

  def about
    @title = 'Sobre el proyecto'
  end
  def sns
    @title = 'Sistema Nacional de Salud'
  end
  def usuarios
    @title = 'Usuarios'
  end
end
