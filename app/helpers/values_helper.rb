# coding: utf-8
# Helper for values we want to show in the home page
#
module ValuesHelper
  def waiting_times
    [
      [:tiempo_espera_medicina_general, 'Médico general'],
      [:tiempo_espera_pediatria, 'Pediatra'],
      [:tiempo_espera_cirugia_general, 'Cirujano general'],
      [:tiempo_espera_ginecotocologia, 'Ginecólogo'],
      [:tiempo_espera_cardiologia, 'Cardiología']
    ]
  end

  def satisfactions
    [
      [:satisfaccion_primer_nivel_atencion_2017, 'Satisfacción'],
      [:conformidad_disponibilidad_agenda_2017, 'Disponibilidad de agenda'],
      [:facilidad_para_realizar_tramites_gestiones_2017, 'Trámites'],
      [:disponibilidad_medicamentos_farmacia_2017, 'Disponibilidad de medicamentos'],
      [:informacion_sobre_derechos_2017, 'Información sobre derechos'],
      [:queja_sugerencia_sabe_donde_dirigirse_2017, 'Recepción de quejas']
    ]
  end

  def rrhh
    [
      [:medicos_generales_policlinica, 'Médico general'],
      [:medicos_de_familia_policlinica, 'Médicos de familia'],
      [:medicos_pediatras_policlinica, 'Pediatras'],
      [:medicos_ginecologos_policlinica, 'Ginecólogos'],
      [:auxiliares_enfermeria_policlinica, 'Aux. de enfermería'],
      [:licenciadas_enfermeria_policlinica, 'Lic. en enfermería']
    ]
  end

  def goals
    # TODO - No sabemos qué datos quieren mostrar de esto, pero esta
    # función se podría generalizar para otras cosas. Si hubiera tiempo...
    (METADATA[:metas][:columns].zip METADATA[:metas][:description]).to_h
  end

  def tickets_show
    [
      [:medicamentos, 'Medicamentos'],
      [:tickets, 'Consultas'],
      [:tickets_urgentes, 'Consultas urgentes'],
      [:estudios, 'Estudios']
    ]
  end

  def self.sites_structure
    [:departamento, :localidad, :nivel]
  end

  def self.sites_data
    METADATA[:sedes][:columns] - ValuesHelper.sites_structure.map(&:to_s) - ['departamento', 'direccion']
  end
end
