# coding: utf-8
module IconsHelper
  def self.render_clocks(provider, value, max)
    return no_data.html_safe unless provider.send(value[0].to_sym)
    display = ''
    # Get the actual value for this column:
    clocks = calculate_value(provider.send(value[0].to_sym), max)
    clocks.times do
      display += "<i class=\"icon-clock\"></i> "
    end
    if clocks < 5
      (5 - clocks).times do
        display += "<i class=\"icon-clock disable\"></i> "
      end
    end
    display.html_safe
  end

  private

  def render_satisfactions(provider)
    html = ''
    values = satisfactions
    # First goal is not percentage, just a value:
    general = values.shift
    html += <<-eos
        <div class="value">
          <label>#{general[1]}</label>
          <h4>#{provider.send(general[0])}</h4>
        </div>
    eos
    # End "Satisfacción con Servicios del Primer Nivel de Atención (2014)"
    values.each do |satisfaction|
      begin
        html += <<-eos
        <div class="value">
          <label>#{satisfaction[1]}</label>
          #{progress_bar(provider.send(satisfaction[0]))}
        </div>
        eos
      rescue
        html += <<-eos
        <div class="value">
          <label>#{satisfaction[1]}</label>
          #{IconsHelper.no_data}
        </div>
        eos
      end
    end
    html
  end

  def self.no_data
    html = <<-eos
    <div class="nodata">
      <p>NO HAY DATOS</p>
      <i class="demo-icon icon-sad"></i>
    </div>
    eos
    html
  end

  def self.calculate_value(value, max)
    if value.to_f > 0 && value.to_f < 1
      value = 1
    else
      value = (value.to_f * 5 / max).round
    end
    value
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
    users.join('').html_safe
  end
end
