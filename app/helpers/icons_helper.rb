# coding: utf-8
module IconsHelper

  def self.render_icons(provider, max, meta, icon_type)
    icons = []
    total = 0
    meta.each do |column, css_class, text|
      value = provider.send(column.to_sym)
      value = calculate_value(value, max)
      value.times do
        icons << "<i class=\"icon-#{icon_type} #{css_class}\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"#{text}\"></i>"
        total += 1
      end
    end
    if icons.count > 0
      while icons.count < 50
        icons << "<i class=\"icon-#{icon_type}\"></i>"
      end
      icons << "<div class=\"hidden\">#{total}</div>" if icon_type == 'clock'
      icons.join("").html_safe
    else
      no_data(icon_type)
    end
  end

  def self.render_money_icons(provider, max)
    unless provider.is_private_insurance?
      meta = [
        [:medicamentos, 'celeste', 'Medicamentos'],
        [:tickets, 'marino', 'Consultas'],
        [:tickets_urgentes, 'azul', 'Consultas urgentes'],
        [:estudios, 'verde', 'Estudios']
      ]
      icons = []
      total = 0
      meta.each do |ticket, css, title|
        a = provider.average(ticket)
        value = calculate_value(a, max)
        value.times do
          total += 1
          icons << "<i class=\"icon-money #{css}\"data-toggle=\"tooltip\" data-placement=\"top\" title=\"#{title}\"></i>"
        end
      end
      while icons.count < 50
        icons << "<i class=\"icon-money\"></i>"
      end
      icons << "<div class=\"hidden\">#{total}</div>"
      icons.join("").html_safe
    else
      data = <<-eos
      <div class="hidden">-1</div>
      #{no_data('money')}
      eos
      data.html_safe
    end
  end

  def self.render_waiting_times(provider, max)
    meta = [
      [:tiempo_espera_medicina_general, 'celeste', 'Médico general'],
      [:tiempo_espera_cirugia_general, 'marino', 'Cirujano general'],
      [:tiempo_espera_pediatria, 'azul', 'Pediatra'],
      [:tiempo_espera_ginecotocologia, 'verde', 'Ginecólogo'],
      [:tiempo_espera_medico_referencia, 'azul_claro', 'Médico de referencia']
    ]
    render_icons(provider, max, meta, 'clock')
  end

  private
  def self.no_data(icon_type)
    # Specify the icon type so we know which column we should modify
    # for the sorting to put them at the bottom
    msg = <<-eos
      <div class="hidden #{icon_type}-no-data-value">-1</div>
      <div class="text-center">
        <i class=\"icon-emo-unhappy\"></i></br>
        No hay datos
      </div>
    eos
    msg.html_safe
  end

  def self.render_users(value, max)
    users = []
    value = calculate_value(value, max)
    value.times do
      users << "<i class=\"icon-user verde\"></i>"
    end
    while users.count < 50
      users << "<i class=\"icon-user\"></i>"
    end
    users.join("").html_safe
  end

  def self.render_hr(provider, max)
    meta = [
      [:medicos_generales_policlinica, 'celeste', "Médico general"],
      [:medicos_de_familia_policlinica, 'marino', "Médicos de familia"],
      [:medicos_pediatras_policlinica, 'azul', "Pediatras"],
      [:medicos_ginecologos_policlinica, 'verde', "Ginecólogos"],
      [:auxiliares_enfermeria_policlinica, 'azul_claro', "Enfermeros"],
      [:licenciadas_enfermeria_policlinica, 'fuxia', "Lic. en enfermería"]
    ]
    render_icons(provider, max, meta, 'user')
  end


  def self.calculate_value(value, max)
    if value.to_f > 0 && value.to_f < 1
      value = 1
    else
      value = (value.to_f * 50 / max).round
    end
    value
  end
end
