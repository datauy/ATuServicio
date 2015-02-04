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

  def show_value(group, column, provider)
    value = ''
    column_value = provider.send(column.to_sym)
    if column == 'web'
      url = column_value
      value = "<a href=\"http://#{url} %>\" title=\"Sitio web\" target=\"_blank\">#{url}</a>".html_safe
    # Check if ASSE because tickets have no cost:
    elsif group == :precios
      if provider.is_asse?
        value = "Sin costo"
      elsif provider.is_private_insurance? && group == :precios
        value = "No hay datos"
      else
        value = "$ #{column_value.round}"
      end
    elsif group == :metas
      result = column_value
      value = (result.is_a? Numeric) ? "#{result} %" : boolean_icons(result)
    elsif group == :tiempos_espera
      value = "#{column_value} días"
    elsif group == :satisfaccion_derechos
      result = column_value
      value = (result) ? "#{result} %" : "No hay datos"
    else
      value = boolean_icons(column_value)
    end
    value
  end
end
