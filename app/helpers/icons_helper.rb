# coding: utf-8
module IconsHelper
  def self.percentage_icons(provider, value, max)
    if value.is_a? Array
      value = provider.send(value[0])
    end
    value * 100 / max
  end

  def ordered_tickets(provider, tipo)
    structure = []
    tickets_show.each do |ticket|
      structure << {
        average: provider.average(ticket[0], tipo),
        label: ticket[1]
      }
    end
    structure.sort! { |x, y| x[:label] <=> y[:label] }
  end

  private

  def percentages_value(provider, value)
    html = ''
    begin
      percentage = provider.send(value[0])
      if percentage.nil?
        html << IconsHelper.no_data
      else
        html << progress_bar(percentage)
      end
    rescue
      html << IconsHelper.no_data
    end
    html
  end
  def percentages_indicator(provider, value)
    html = ''
    begin
      percentage = IndicatorActive.
      includes(indicator: :provider_relations).
      where(active: true, "indicators.key": value, "provider_relations.provider_id": provider).
      pluck("provider_relations.indicator_value").first
      if percentage.nil?
        html << IconsHelper.no_data
      else
        html << progress_bar(percentage)
      end
    rescue
      html << IconsHelper.no_data
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
end
