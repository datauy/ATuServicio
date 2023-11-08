# coding: utf-8
module CompareHelper
  NC = 'No corresponde'.freeze

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
      elsif ['espacio_adolescente', 'servicios_atencion_adolescentes'].include? column
        value = if column_value.nil?
                  ApplicationHelper.no_hay_datos
                else
                  table_cell(boolean_icons(column_value))
                end
      else
        value = table_cell("<p>#{column_value}</p>")
      end
    when :precios
      value = precios_value(provider, column_value)
    when :metas
      value = meta_value(column_value, provider.id, column)
    when :tiempos_espera
      ctype = column.split('_')
      wtype = ctype[-1]
      ctype.delete_at(-1)
      main_type = ctype.join('_')
      if column_value
        indicator = check_enough_data_times(column, provider)
        calculado = ''
        if !(wtype == 'presencial' || wtype == 'virtual') && provider.send("#{column}_virtual".to_sym) && provider.send("#{column}_presencial".to_sym)
          calculado = '<a class="info" href="#" data-toggle="modal" data-target="#tiempos_espera_promedios_modal">Promedio calculado <i class="icon-info"></i></a>'
        end
        tiempo = "#{column_value} <small>DÍAS</small>"
        value = "<td>#{calculado}<h5>#{tiempo} #{indicator}</h5></td>"
      elsif (wtype == 'presencial' || wtype == 'virtual') && provider.send(main_type.to_sym)
        if wtype == 'virtual' && provider.send("#{main_type}_presencial".to_sym)
          value = "<td><span class='info'>No corresponde</span></td>"
        else
          value = "<td><span class='info'>Sin discriminar</span></td>"
        end
      else
        value = ApplicationHelper.no_hay_datos
      end
    when :satisfaccion_derechos
      value = if column_value
                if [
                  'satisfaccion_primer_nivel_atencion_2014',
                  'satisfaccion_primer_nivel_atencion_2017',
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
      value = rrhh_value(column, column_value, provider.id)
    when :solicitud_consultas
      value = appointment_request_value(column_value)
    else
      value = table_cell(boolean_icons(column_value))
    end
    value.to_s.html_safe
  end

  def precios_value(provider, column_value)
    if provider.asse? || column_value == 0
      sin_costo
    elsif !column_value
      ApplicationHelper.no_hay_datos
    else
      price = number_to_currency(
        column_value,
        delimiter: StringConstants::DOT,
        separator: StringConstants::COMMA,
        unit: StringConstants::PESOS,
      )
      table_cell("<h5>#{price}</h5>")
    end
  end

  def meta_value(column_value, id, column)
    # El proveedor con id 9508 tiene una excepción en este valor, por lo que no
    # se debe evaluar este valor:
    if id == 9508 && column == 'capacitacion_infarto_st_elevado'
      table_cell(NC)
    elsif column_value.is_a? Numeric
      table_cell(progress_bar(column_value))
    elsif column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass)
      table_cell(boolean_icons(column_value))
      table_cell(column_value)
    else
      ApplicationHelper.no_hay_datos
    end
  end

  def rrhh_value(column, column_value, provider_id)
    value = (column_value) ? column_value : nil
    if value.nil?
      ApplicationHelper.no_hay_datos
    else
      if column == 'proporcion_trabajadores_seminario_2017'
        table_cell(progress_bar(column_value))
      elsif provider_id != 9000 &&
          ['cantidad_cad_medicina_rural', 'cantidad_cad_anestesia'].include?(column)
        table_cell(NC)
      else
        table_cell(value)
      end
    end
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
    if @selected_providers.select { |p| p.id == 9000 }.present?
      value = case group
              when :tiempos_espera
                <<-eos
                <tr><td colspan="5">
                <div class="asse">
                #{render 'layouts/asse_tiempos_espera_info'}
                </div></td></tr>
                eos
              when :satisfaccion_derechos
                "#{render 'layouts/asse_satisfaccion'}"
              end
    end
    value.html_safe if value
  end

  def cad_abbr(value)
    value.gsub('CAD', '<abbr title=\'Cargos de Alta Dedicaci&oacute;n\'>CAD</abbr>').html_safe
  end

  def sin_costo
    "<td class=\"free\"><p>GRATUITO</p><i class=\"demo-icon icon-happy\"></td>".html_safe
  end

  def progress_bar(value)
    <<-eos
    <div class="progress">
      <div class="progress-bar" role="progressbar" aria-valuenow="#{value}" aria-valuemin="0" aria-valuemax="100" style="width: #{value}%;">
        <span class="sr-only">#{sprintf("%g", value)}%</span>
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

  def show_site_data(site, type)
    html = ''
    ValuesHelper.send("sites_#{type}".to_sym).each do |value|
      html << "<tr><td>#{value.to_s.split('_').join(' ').capitalize}:"
      unless site.send(value).nil?
        info = site.send(value)
        if info.is_a?(TrueClass) || info.is_a?(FalseClass)
          info = boolean_icons(info)
        else
          info = info.capitalize
        end
        html << <<-eos
          #{info}</tr></td>
        eos
      else
        html << "<span class='nodata'>#{ApplicationHelper.no_hay_datos(false)}</span>"
      end
    end
    html.html_safe
  end

  def any_recognitions?
    @selected_providers.map{ |p| p.recognitions.size }.sum > 0
  end
end
