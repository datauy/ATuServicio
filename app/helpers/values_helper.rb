# coding: utf-8
# Helper for values we want to show in the home page
#
module ValuesHelper
  def waiting_times
    {
      promedios: {
        tiempo_espera_medicina_general: 'Medicina general',
        tiempo_espera_pediatria: 'Pediatría',
        tiempo_espera_cirugia_general: 'Cirujía general',
        tiempo_espera_ginecotocologia: 'Ginecotocología',
        tiempo_espera_cardiologia: 'Cardiología',
      },
      virtuales: {
        tiempo_espera_medicina_general_virtual: 'Medicina general',
        tiempo_espera_pediatria_virtual: 'Pediatría',
        tiempo_espera_cirugia_general_virtual: 'Cirujía general',
        tiempo_espera_ginecotocologia_virtual: 'Ginecotocología',
        tiempo_espera_cardiologia_virtual: 'Cardiología',
      },
      presenciales: {
        tiempo_espera_medicina_general_presencial: 'Medicina general',
        tiempo_espera_pediatria_presencial: 'Pediatría',
        tiempo_espera_cirugia_general_presencial: 'Cirujía general',
        tiempo_espera_ginecotocologia_presencial: 'Ginecotocología',
        tiempo_espera_cardiologia_presencial: 'Cardiología'
      }
    }
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
      [:medicos_generales_policlinica, 'Médicina general'],
      [:medicos_de_familia_policlinica, 'Médicina de familia'],
      [:medicos_pediatras_policlinica, 'Pediatría'],
      [:medicos_ginecologos_policlinica, 'Ginecotocología'],
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
