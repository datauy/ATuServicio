class UpdateSatisfaccionInProviders < ActiveRecord::Migration
  def change
    %i[conformidad_disponibilidad_agenda_2010 evaluacion_tiempo_espera_sala_2010
       facilidad_para_realizar_tramites_gestiones_2010
       disponibilidad_medicamentos_farmacia_2014
       disponibilidad_medicamentos_farmacia_2010 informacion_sobre_derechos_2014
       informacion_sobre_derechos_2010
       queja_sugerencia_sabe_donde_dirigirse_2010
       satisfaccion_primer_nivel_atencion_2010].each do |old|
      remove_column :providers, old if column_exists?(:providers, old)
    end

    %i[
      conformidad_disponibilidad_agenda_2017
      evaluacion_tiempo_espera_sala_2017
      facilidad_para_realizar_tramites_gestiones_2017
      disponibilidad_medicamentos_farmacia_2017
      informacion_sobre_derechos_2017
      queja_sugerencia_sabe_donde_dirigirse_2014
      queja_sugerencia_sabe_donde_dirigirse_2017
      satisfaccion_primer_nivel_atencion_2017
      satisfaccion_primer_nivel_atencion_2014
    ].each do |new|
      add_column :providers, new, :decimal unless column_exists?(:providers, new)
    end
  end
end
