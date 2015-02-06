# coding: utf-8
module CompareHelper
  def title(group)
    METADATA[group][:title]
  end

  def site_column_exceptions
    [:id, :provider_id, :created_at, :updated_at, :direccion,
     :departamento, :localidad, :nivel, :servicio_de_urgencia]
  end

  def waiting_times
    [:tiempo_espera_medicina_general, :tiempo_espera_pediatria,
     :tiempo_espera_cirugia_general, :tiempo_espera_ginecotocologia,
     :tiempo_espera_medico_referencia]
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
      value = (column_value) ? "#{column_value} %" : "No hay datos"
    # FIX: This is a hack
    # MP and Britanico - 9508 9532
    # We are doing this because (for now) the importer turns 0 values
    # from the open data into nil, which we *should fix* asap
    elsif group == :rrhh
      value = rrhh_value(provider, column_value, column)
    else
      value = boolean_icons(column_value)
    end
    value
  end

  def precios_value(provider, column_value)
    if provider.is_asse?
      value = "Sin costo"
    elsif provider.is_private_insurance?
      value = "No hay datos"
    else
      value = "$ #{column_value.round}"
    end
    value
  end

  def meta_value(column_value)
    (column_value.is_a? Numeric) ? "#{column_value} %" : boolean_icons(column_value)
  end

  def rrhh_value(provider, column_value, column)
    value = nil
    if [9508, 9532].include?(provider.id)
      value = (column_value) ? "#{column_value}" : 0
    elsif provider.is_private_insurance? && column.match(/_cad$/)
      value = 0
    else
      value = column_value || "No hay datos"
    end
    value
  end

  def check_enough_data_times(column, provider)
    if !provider.send("datos_suficientes_#{column}")
      info = "Estos datos se elaboraron con una muestra de menos del 10% de la consulta"
      "<span class=\"glyphicon glyphicon-info-sign\" title=\"#{info}\"> </span>"
    end
  end

  def custom_asse_message(group)
    value = ''
    if group == :tiempos_espera && @selected_providers.select { |p| p.nombre_abreviado.include? "ASSE" }.count > 0
    value =  <<-eos
  <tr>
    <td colspan="4">
      <strong>
      ASSE: Promedios de tiempos de espera calculados con información correspondiente a 142 unidades asistenciales de un total de 800. Siendo de las 142, la mayoría Unidades de Primer Nivel de Atención del interior del país, donde las especialidades tienen una oferta limitada.
      </strong>
    </td>
  </tr>
      eos
    end
    value.html_safe
  end

  def cad_abbr(value)
    value.gsub("CAD", "<abbr title=\"Cargos de Alta Direcci&oacute;n\">CAD</abbr>").html_safe
  end
end
