module SiteHelper

  def get_site_tags(ttype)
    res = ''
    case ttype
    when 'level'
      case @site.category
      when 'CENTRO DE SALUD'
        res += "<div class='tag secondLevel'><span>Centro de salud</span></div>"
      when 'HOSPITAL'
        res += "<div class='tag thirdLevel'><span>Hospital</span></div>"
      else
        res += "<div class='tag firstLevel'><span>Policlínica</span></div>"
      end
      if @site.geo_entities.present?
        res += "<div class='tag vac'><span>Vaunatorio</span></div>"
      end
      urgence = @site.site_data.where(datum_id: @urgence_id)
      if urgence.present? && urgence.first.value == 1
        res += "<div class='tag emergency'><span>Puerta de urgencia</span></div>"
      end
    when 'address'
      geo = @site.zone.parents
      geo.keys.reverse_each do |zkey|
        res += "<div class='tag location #{zkey.downcase}'><span>#{geo[zkey].name}</span></div>"
      end
      res += self.site_address('tag location')
    end
    res.html_safe
  end

  def site_address(sclass = 'column')
    addrs = []
    ['address', 'address_comp', 'highway', 'highway_km'].each do |addr|
      addrs.push(@site[addr]) if @site[addr].present? 
    end
    if addrs.length > 0
      "<div class='address #{sclass}'><span>#{addrs.join(', ')}</span></div>".html_safe
    else
      ""
    end
  end
end