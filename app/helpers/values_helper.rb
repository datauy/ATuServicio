# coding: utf-8
module ValuesHelper
  def waiting_times
    [
      [:tiempo_espera_medicina_general, 'Médico general'],
      [:tiempo_espera_cirugia_general, 'Cirujano general'],
      [:tiempo_espera_pediatria, 'Pediatra'],
      [:tiempo_espera_ginecotocologia, 'Ginecólogo']
    ]
  end

  def satisfactions
    [
      [:satisfaccion_primer_nivel_atencion_2014, 'Satisfacción'],
      [:conformidad_disponibilidad_agenda_2014, 'Disponibilidad de agenda'],
      [:facilidad_para_realizar_tramites_gestiones_2014, 'Trámites'],
      [:disponibilidad_medicamentos_farmacia_2014, 'Disponibilidad de medicamentos'],
      [:informacion_sobre_derechos_2014, 'Información sobre derechos'],
      [:queja_sugerencia_sabe_donde_dirigirse_2014, 'Recepción de quejas']
    ]
  end

  def rrhh
    [
      [:medicos_generales_policlinica, 'Médico general'],
      [:medicos_de_familia_policlinica, 'Médicos de familia'],
      [:medicos_pediatras_policlinica, 'Pediatras'],
      [:medicos_ginecologos_policlinica, 'Ginecólogos'],
      [:auxiliares_enfermeria_policlinica, 'Enfermeros'],
      [:licenciadas_enfermeria_policlinica, 'Lic. en enfermería']
    ]
  end

  def goals
    [
      [:meta_embarazadas, 'Embarazadas correct. controladas (%)'],
      [:meta_ninos_controlados, ' Niños (1 año) correct. controlados (%)']
    ]
  end

  def tickets_show
    [
      [:medicamentos, 'Medicamentos'],
      [:tickets, 'Consultas'],
      [:tickets_urgentes, 'Consultas urgentes']
    ]
  end
end
