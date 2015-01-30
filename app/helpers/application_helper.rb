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
end
