module ApplicationHelper
  def waiting_times
    [:tiempo_espera_medicina_general, :tiempo_espera_pediatria,
     :tiempo_espera_cirugia_general, :tiempo_espera_ginecotocologia,
     :tiempo_espera_medico_referencia]
  end

  def columns_name_description(group)
    group_names = METADATA[group][:description]
    group_descriptions = METADATA[group][:columns]

    groups = group_names.zip(group_descriptions)
    # Remove web since we show it elsewhere:
    groups.delete(['Web', 'web'])
    groups
  end

  def state_options(states)
    (['Todo el pais'] + states).zip(['todos'] + to_class_names(states))
  end

  def provider_options
    @providers.order(:nombre_abreviado).map do |p|
      [
        p.nombre_abreviado,
        p.id,
        { class: (['todos'] + to_class_names(p.states)).join(' ') }
      ]
    end
  end

  def to_class_names(elements)
    elements.map { |s| s.downcase.gsub(' ', '_') }
  end

  def show_if_valid(provider, field)
    enough_data_field = "datos_suficientes_#{field}"
    if provider.send(enough_data_field)
      provider.send(field)
    else
      nil
    end
  end

  # Returns true, false, or question mark if value not present
  def boolean_icons(value)
    return"<i class=\"demo-icon icon-ok\"></i>".html_safe if value.is_a?(TrueClass)
    return "<i class=\"demo-icon icon-no\"></i>".html_safe if value.is_a?(FalseClass)
    return no_hay_datos unless value
    value
  end

  def no_hay_datos
    "<td class=\"nodata\"><p>NO HAY DATOS</p><i class=\"demo-icon icon-sad\"></i></td>".html_safe
  end
end
