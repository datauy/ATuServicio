# coding: utf-8
class HomeController < ApplicationController
  layout 'atuservicio'
  caches_action :load_options

  before_filter :load_options

  def load_options
    @providers ||= Provider.select(
      'id',
      'nombre_abreviado',
      'nombre_completo',
      'web',
      'estructura_primaria',
      'estructura_secundaria',
      'estructura_ambulatorio',
      'estructura_urgencia',
      'afiliados',
      'tiempo_espera_medicina_general',
      'tiempo_espera_cirugia_general',
      'tiempo_espera_pediatria',
      'tiempo_espera_ginecotocologia',
      'tiempo_espera_cardiologia',
      'medicos_generales_policlinica',
      'medicos_de_familia_policlinica',
      'medicos_pediatras_policlinica',
      'medicos_ginecologos_policlinica',
      'auxiliares_enfermeria_policlinica',
      'licenciadas_enfermeria_policlinica',
      'captacion_rn',
      'control_desarrollo',
      'control_embarazo_hiv_vdrl',
      'control_pauta_25_a_64_hipertensos',
      'capacitacion_infarto_st_elevado',
      'indice_cesareas',
      'satisfaccion_primer_nivel_atencion_2017',
      'conformidad_disponibilidad_agenda_2017',
      'facilidad_para_realizar_tramites_gestiones_2017',
      'disponibilidad_medicamentos_farmacia_2017',
      'informacion_sobre_derechos_2017',
      'queja_sugerencia_sabe_donde_dirigirse_2017',
      'ticket_de_medicamentos_general_fonasa',
      'ticket_de_medicamentos_topeados_fonasa',
      'consulta_medicina_general_fonasa',
      'consulta_pediatria_fonasa',
      'consulta_control_de_embarazo_fonasa',
      'consulta_ginecologia_fonasa',
      'consulta_otras_especialidades_fonasa',
      'consulta_odontologica_fonasa',
      'consulta_medico_de_referencia_fonasa',
      'consulta_urgencia_centralizada_fonasa',
      'consulta_urgencia_domicilio_fonasa',
      'endoscopia_digestiva_endoscopia_fonasa',
      'ecografia_simple_fonasa',
      'ecodoppler_fonasa',
      'rx_simple_fonasa',
      'rx_torax_fonasa',
      'rx_colorectal_fonasa',
      'resonancia_fonasa',
      'tomografia_fonasa',
      'laboratorio_rutina_basica_fonasa'
    ).includes(:states).all
    @states ||= State.all
  end

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
                       state.providers.order(:private_insurance).order(:nombre_abreviado).uniq
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
