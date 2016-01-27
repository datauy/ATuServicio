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
  def show_value(group, column, provider)
    value = ''
    unless column
      return ApplicationHelper.no_hay_datos
    end
    column_value = provider.send(column.to_sym)
    case group
    when :estructura
      if ['afiliados', 'afiliados_fonasa'].include? column
        value = table_cell("<h5 class=\"people people-high\">#{number_with_delimiter(column_value, delimiter: '.')}</h5>")
      else
        value = table_cell("<p>#{column_value}</p>")
      end
    when :precios
      value = precios_value(provider, column_value)
    when :metas
      value = meta_value(column_value)
      if provider.id == 9000
        metas_asse(column, value)
      end
    when :tiempos_espera
      if column_value
        indicator = check_enough_data_times(column, provider)
        value = "<td><h5>#{column_value} <small>DÍAS</small> #{indicator}</h5></td>"
      else
        value = ApplicationHelper.no_hay_datos
      end
    when :satisfaccion_derechos
      value = if (column_value)
                if [
                  'satisfaccion_primer_nivel_atencion_2014',
                  'satisfaccion_primer_nivel_atencion_2010',
                  'satisfaccion_internacion_hospitalaria_2012'
                ].include? column
                  table_cell("<p>#{column_value}</p>")
                else
                  table_cell(progress_bar(column_value))
                end
              else
                ApplicationHelper.no_hay_datos
              end
    when :rrhh
      value = rrhh_value(provider, column_value, column)
    when :solicitud_consultas
      value = appointment_request_value(column_value)
    else
      value = table_cell(boolean_icons(column_value))
    end
    value.to_s.html_safe
  end

  def metas_asse(column, value)
    modal = nil
    case column
    when 'espacio_adolescente'
      modal = <<-eos
        <i class="demo-icon icon-info" data-toggle="modal"
        data-target="#asse_espacio_modal"></i></td>
      eos
    when 'meta_ninos_controlados', 'meta_embarazadas'
      modal = <<-eos
        <i class="demo-icon icon-info" data-toggle="modal"
        data-target="#asse_metas_modal"></i></td>
      eos
    end
    if modal
      value.gsub!(
        '</td>',
        "<a href='#'>#{modal}</a></td>"
      )
    else
      value
    end
  end

  def precios_value(provider, column_value)
    if provider.asse?
      sin_costo
    elsif provider.private_insurance || !column_value
      ApplicationHelper.no_hay_datos
    else
      table_cell("<p>$ #{number_with_delimiter(column_value, separator: ',')}</p>")
    end
  end

  def meta_value(column_value)
    if column_value.is_a? Numeric
      table_cell(progress_bar(column_value))
    elsif column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass)
      table_cell(boolean_icons(column_value))
    else
      ApplicationHelper.no_hay_datos
    end
  end

  def rrhh_value(provider, column_value, column)
    value = nil
    # TODO - Check if this is still an issue:
    # FIX: This is a hack
    # MP and Britanico - 9508 9532
    # We are doing this because (for now) the importer turns 0 values
    # from the open data into nil, which we *should fix* asap
    if [9508, 9532].include?(provider.id)
      value = (column_value) ? column_value : 0
    elsif provider.private_insurance && column.match(/_cad$/)
      value = 0
    else
      value = (column_value) ? column_value : nil
    end
    value.nil? ? ApplicationHelper.no_hay_datos : table_cell(value)
  end

  def appointment_request_value(column_value)
    no_icon = "<i class=\"demo-icon icon-no\"></i>"
    yes_icon = "<i class=\"demo-icon icon-ok\"></i>"
    return table_cell(no_icon) if column_value == 'f'
    return table_cell(yes_icon) if column_value == 't'
    if /^(S[í|I|i],?\s?)(.+)/.match(column_value)
      match = /^(S[í|I|i],?\s?)(.+)/.match(column_value)
      return table_cell("#{yes_icon}<p>#{match[2].capitalize}</p>")
    end
    column_value ? table_cell(column_value) : ApplicationHelper.no_hay_datos
  end

  def check_enough_data_times(column, provider)
    unless provider.send("datos_suficientes_#{column}")
      info = "Estos datos se elaboraron con una muestra de menos del 10% de la consulta"
      "<i class=\"demo-icon icon-info\" title=\"#{info}\"> </i>"
    end
  rescue
  end

  def custom_asse_message(group)
    value = ''
    if @selected_providers.select { |p| p.nombre_abreviado.include? 'ASSE' }.count > 0
      case group
      when :tiempos_espera
        value = <<-eos
        <tr><td colspan="5">
        <p class="asse">
        #{asse_waiting_times}
        </p></td></tr>
        eos
      when :satisfaccion_derechos
        value = <<-eos
        <tr><td colspan="5">
        <p class="asse">
        Ver resultados de encuestas de satisfacción en<br>
        <a
    href="http://www.asse.com.uy/contenido/Movilidad-Regulada-8431" target="_blank">http://www.asse.com.uy/contenido/Movilidad-Regulada-8431</a>
        <br>
        Los datos de las Encuestas de Satisfacción sobre los Servicios
        del Primer Nivel de Atención (2014 y 2010) correspondientes a
        ASSE no son estrictamente comparables para esos dos años,
        debido a aspectos de conformación y alcance de la muestra
        </p></td></tr>
        eos
      end
    end

    value.html_safe
  end

  def cad_abbr(value)
    value.gsub('CAD', '<abbr title=\'Cargos de Alta Direcci&oacute;n\'>CAD</abbr>').html_safe
  end

  def sin_costo
    "<td class=\"free\"><p>SIN COSTO</p><i class=\"demo-icon icon-happy\"></td>".html_safe
  end

  def progress_bar(value)
    <<-eos
    <div class="progress">
      <div class="progress-bar" role="progressbar" aria-valuenow="#{value}" aria-valuemin="0" aria-valuemax="100" style="width: #{value}%;">
        <span class="sr-only">#{number_with_delimiter(value, separator: ',')}%</span>
      </div>
    </div>
    eos
  end

  def share_message
    providers = @selected_providers.map{ |n| n.nombre_abreviado.split.map(&:capitalize)*' ' }.join(', ')
    "Comparando #{providers} en AtuServicio.uy"
  end

  def current_url
    URI.encode(request.original_url)
  end

  def table_cell(value)
    "<td>#{value}</td>"
  end
end
