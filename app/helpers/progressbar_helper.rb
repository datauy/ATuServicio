# coding: utf-8
module ProgressbarHelper
  def self.render_satisfaction(provider)
    satisfaccion = provider.satisfaccion_primer_nivel_atencion_2014 * 10 if provider.satisfaccion_primer_nivel_atencion_2014
    meta = [
      [satisfaccion, 'celeste', 'Satisfacción'],
      [:disponibilidad_agenda_2014, 'marino', 'Disponibilidad de agenda'],
      [:facilidad_para_realizar_tramites_gestiones_2014, 'azul', 'Trámites'],
      [:disponibilidad_medicamentos_farmacia_2014, 'verde', 'Disponibilidad de medicamentos'],
      [:informacion_sobre_derechos_2014, 'azul_claro', 'Información sobre derechos'],
      [:queja_sugerencia_sabe_donde_dirigirse_2014, 'fuxia', 'Recepción de quejas']
    ]
    render_bars(provider, meta)
  end

  def self.render_goals(provider)
    meta = [
      [:meta_medico_referencia, 'celeste', 'Afiliados c/médico de referencia (%)'],
      [:meta_embarazadas, 'marino', 'Embarazadas correct. controladas (%)'],
      [:meta_ninos_controlados, 'azul', ' Niños (1 año) correct. controlados (%)']
    ]
    render_bars(provider, meta)
  end

  # Once we have the meta info, render a bar per value
  def self.render_bars(provider, meta)
    html = ''
    meta.each do |indicator, css_class, title|
      if indicator.is_a?(Symbol)
        if provider.respond_to?(indicator)
          html += render_single_bar(provider.send(indicator), css_class, title)
        end
      else
        html += render_single_bar(indicator, css_class, title)
      end
    end
    html.html_safe
  end

  # HTML for each bar:
  def self.render_single_bar(object, css_class, title = nil)
    if object && object.is_a?(BigDecimal)
      value = (object > 10) ? "#{object} %" : object
      <<-eos
        <div class="progress">
          <div class="progress-bar #{css_class}" role="progressbar" aria-valuenow="#{object}" aria-valuemin="0" aria-valuemax="100" style="width: #{object}%;" data-toggle="tooltip" data-placement="top" title="#{title}">
          #{value}
          </div>
        </div>
      eos
    else
      <<-eos
        <div class="progress">
          <div class="progress-bar no-data" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
            No hay datos <i class="icon-emo-unhappy"></i>
          </div>
        </div>
      eos
    end
  end

end
