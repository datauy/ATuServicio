# coding: utf-8
module CompareHelper
  def title(group)
    METADATA[group][:title]
  end

  def site_column_exceptions
    [:id, :provider_id, :created_at, :updated_at, :direccion,
     :departamento, :localidad, :nivel, :servicio_de_urgencia]
  end

  def ticket_prices
    METADATA[:precios][:columns]
  end

  # TODO Refactor
  # FIX Fix this uglyness:
  def show_value(group, column, provider)
    value = ''
    column_value = provider.send(column.to_sym)
    if column == 'web'
      value = "<a href=\"http://#{column_value}\" title=\"Sitio web\" target=\"_blank\">#{column_value}</a>".html_safe
    # Check if ASSE because tickets have no cost:
    elsif group == :precios
      value = precios_value(provider, column_value)
    elsif group == :metas
      value = meta_value(column_value)
    elsif group == :tiempos_espera
      indicator = check_enough_data_times(column, provider)
      value = "#{column_value} días #{indicator}".html_safe
    elsif group == :satisfaccion_derechos
      value = if (column_value)
                progress_bar(column_value).html_safe
              else
                no_hay_datos
              end
    # FIX: This is a hack
    # MP and Britanico - 9508 9532
    # We are doing this because (for now) the importer turns 0 values
    # from the open data into nil, which we *should fix* asap
    elsif group == :rrhh
      value = rrhh_value(provider, column_value, column)
    elsif group == :solicitud_consultas
      value = appointment_request_value(column_value)
    else
      value = boolean_icons(column_value)
    end
    value
  end

  def precios_value(provider, column_value)
    if provider.asse?
      value = sin_costo
    elsif provider.private_insurance
      value = no_hay_datos
    else
      value = "$ #{column_value.round}"
    end
    value
  end

  def meta_value(column_value)
    if column_value.is_a? Numeric
      progress_bar(column_value).html_safe
    else
      boolean_icons(column_value)
    end
  end

  def rrhh_value(provider, column_value, column)
    value = nil
    if [9508, 9532].include?(provider.id)
      value = (column_value) ? "#{column_value}" : 0
    elsif provider.private_insurance && column.match(/_cad$/)
      value = 0
    else
      value = column_value || no_hay_datos
    end
    value
  end

  def appointment_request_value(column_value)
    return 'No' if column_value == 'f'
    return 'Sí' if column_value == 't'
    column_value
  end

  def check_enough_data_times(column, provider)
    unless provider.send("datos_suficientes_#{column}")
      info = "Estos datos se elaboraron con una muestra de menos del 10% de la consulta"
      "<span class=\"glyphicon glyphicon-info-sign\" title=\"#{info}\"> </span>"
    end
  rescue
  end

  def custom_asse_message(group)
    value = ''
    if group == :tiempos_espera && @selected_providers.select { |p| p.nombre_abreviado.include? 'ASSE' }.count > 0
    value =  <<-eos
  <tr>
    <td colspan="4">
      <p class="asse">
      ASSE: Promedios de tiempos de espera calculados con información correspondiente a 142 unidades asistenciales de un total de 800. Siendo de las 142, la mayoría Unidades de Primer Nivel de Atención del interior del país, donde las especialidades tienen una oferta limitada.
      </p>
    </td>
  </tr>
      eos
    end
    value.html_safe
  end

  def cad_abbr(value)
    value.gsub('CAD', '<abbr title=\'Cargos de Alta Direcci&oacute;n\'>CAD</abbr>').html_safe
  end

  def sin_costo
    "<p class=\"free\">SIN COSTO</p><i class=\"demo-icon icon-happy\">".html_safe
  end

  def progress_bar(value)
    <<-eos
      <div class="progress">
        <div class="progress-bar" role="progressbar" aria-valuenow="#{value}" aria-valuemin="0" aria-valuemax="100" style="width: #{value}%;">
        </div>
        <span class="sr-only">#{value}%</span>
      </div>
    eos
  end

  def share_message
    providers = @selected_providers.map{ |n| n.nombre_abreviado.downcase.capitalize }.join(", ")
    "Comparando #{providers} en AtuServicio.uy - #{URI.encode(request.original_url)}"
  end
end
