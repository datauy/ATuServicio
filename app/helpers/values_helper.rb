# coding: utf-8
# Helper for values we want to show in the home page
#
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


  def asse_waiting_times
    <<-eos
    ASSE desarrolló en el año 2012  el Sistema de Gestión Consultas (SGC) (Sistema web), que se encuentra en proceso de expansión en todo el país, tanto en el primer, como segundo y tercer nivel de atención. Actualmente se encuentra en 221 Unidades Asistenciales, de las cuales 32 son Hospitales o Centros Auxiliares, 24 son Centros de Salud y 165 son Policlínicas. Se prevé que para finales del 2018 estará implantado en todo el país. Sin embargo, los datos de tiempo de espera que surgen actualmente del SGC no son representativos de toda la institución, ni de sus diferentes niveles de complejidad.<br>Ver información complementaria en<br><a
    href="http://www.asse.com.uy/contenido/Movilidad-Regulada-8431" target="_blank">http://www.asse.com.uy/contenido/Movilidad-Regulada-8431</a>
    eos
  end
end
