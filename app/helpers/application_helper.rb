module ApplicationHelper
  def columns_name_description(group)
    group_names = METADATA[group][:description]
    group_descriptions = METADATA[group][:columns]

    group_names.zip(group_descriptions)
  end

  def state_options
    states = State.all
    (["Todo el pais"] + states).zip(["todos"] + to_class_names(states))
  end

  def provider_options
    Provider.all.map{ |p| [p.nombre_abreviado, p.id, {class: (["todos"] + to_class_names(p.states)).join(" ")}] }
  end

  def to_class_names(elements)
    elements.map{|s| s.downcase.gsub(" ", "_")}
  end

  def show_if_valid(provider, field)
    enough_data_field = "datos_suficientes_#{field}"
    if provider.send(enough_data_field)
      provider.send(field)
    else
      "Sin suficientes datos"
    end
  end

  def progress_bar(object, css_class)
    if object && object.is_a?(BigDecimal)
      <<-eos
        <div class="progress">
          <div class="progress-bar #{css_class}" role="progressbar" aria-valuenow="#{object}" aria-valuemin="0" aria-valuemax="100" style="width: #{object}%;">
          #{object}
          </div>
        </div>
      eos
    else
      <<-eos
        <div class="progress">
          <div class="progress-bar no-data" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
            No hay datos
          </div>
        </div>
      eos
    end
  end

  def provider_structure(provider)
    states = provider.states
    structures = {
      primaria: 0,
      secundaria: 0,
      ambulatorio: 0,
      urgencia: 0
    }
    states.each do | state |
      structures[:primaria] += provider.coverage_by_state(state, 'Sede Central')
      structures[:secundaria] += provider.coverage_by_state(state, 'Sede Secundaria')
      structures[:ambulatorio] += provider.coverage_by_state(state, 'Ambulatorio')
      structures[:urgencia] += provider.coverage_by_state(state, 'Urgencia')
    end
    structures
  end

  def boolean_icons(value)
    return"<i class=\"icon-tick\"></i>".html_safe if value.is_a?(TrueClass)
    return "<i class=\"icon-cross\"></i>".html_safe if value.is_a?(FalseClass)
    value
  end
end
