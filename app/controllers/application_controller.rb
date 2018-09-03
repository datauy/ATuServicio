class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
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
end
