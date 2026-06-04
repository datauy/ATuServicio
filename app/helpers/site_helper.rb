module SiteHelper

  def get_site_tags(ttype)
    res = ''
    case ttype
    when 'level'
      @site.site_data.pluck(:level).uniq.each do |level|
        case level
        when 'Primer nivel de atención'
          res += "<div class='tag firstLevel'><span>Policlínica</span></div>"
        when 'Segundo nivel de atención'
          res += "<div class='tag secondLevel'><span>Centro de salud</span></div>"
        when 'Tercer nivel de atención'
          res += "<div class='tag thirdLevel'><span>Hospital</span></div>"
        end
      end
      if @site.geo_entities.present?
        res += "<div class='tag vac'><span>Vaunatorio</span></div>"
      end
      emergency = @site.site_data.where(datum_id: @emergency_id)
      if emergency.present? && emergency
        res += "<div class='tag emergency'><span>Puerta de emergencia</span></div>"
      end
    when 'address'
      geo = @site.zone.parents
      geo.keys.reverse_each do |zkey|
        res += "<div class='tag location #{zkey.downcase}'><span>#{geo[zkey].name}</span></div>"
      end
    end
    res.html_safe
  end

  def site_address(sclass = 'column')
    addrs = []
    ['address', 'address_comp', 'highway', 'highway_km'].each do |addr|
      addrs.push(@site[addr]) if @site[addr].present? 
    end
    if addrs.length > 0
      "<div class='address #{sclass}'><b>Dirección</b><span>#{addrs.join(', ')}</span></div>".html_safe
    else
      ""
    end
  end
end