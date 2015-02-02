module ApplicationHelper
  def columns_name_description(group)
    group_names = METADATA[group][:description]
    group_descriptions = METADATA[group][:columns]

    group_names.zip(group_descriptions)
  end

  def state_options
    states = State.all
    (["Todo el pais"] + states).zip(["todos"] + State.map(&:id))
  end

  def provider_options
    Provider.all.map{ |p| [p.nombre_abreviado, p.id, {class: (["todos"] + p.states.map(&:id).join(" ")}] }
  end

  # def to_class_names(elements)
  #   elements.map{|s| s.downcase.gsub(" ", "_")}
  # end

  def show_if_valid(provider, field)
    enough_data_field = "datos_suficientes_#{field}"
    if provider.send(enough_data_field)
      provider.send(field)
    else
      nil
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

  def build_icon_rows(provider, max, meta, icon_type)
    icons = []
    meta.each do |column, css_class|
      value = show_if_valid(provider, column)
      break unless value
      value = calculate_value(value, max)
      value.times do
        icons << "<i class=\"icon-#{icon_type} #{css_class}\"></i>"
      end
    end
    while icons.count < 50
      icons << "<i class=\"icon-#{icon_type}\"></i>"
    end
    icons.join("").html_safe
  end

  def build_icon_money(provider, max, prices)
    icons = []
    prices.each do |ticket, css|
      a = provider.average(ticket)
      value = calculate_value(a, max)
      value.times do
        icons << "<i class=\"icon-money #{css}\"></i>"
      end
    end
    while icons.count < 50
      icons << "<i class=\"icon-money\"></i>"
    end
    icons.join("").html_safe
  end

  def show_users(value, max)
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

  def calculate_value(value, max)
    if value.to_f > 0 && value.to_f < 1
      value = 1
    else
      value = (value.to_f * 50 / max).round
    end
    value
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
