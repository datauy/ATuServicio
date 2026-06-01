module SiteHelper

  def get_site_tags(ttype)
    res = ''
    case ttype
    when 'level'
      @site.site_data.pluck(:level).uniq.each do |level|
        case level
        when 'Primer nivel de atención'
          res += "<div class='tag poli'>#{svg('primer-nivel-de-atencion.svg')}<span>Policlínica</span></div>"
        when 'Segundo nivel de atención'
          res += "<div class='tag center'>#{svg('housemedical.svg')}<span>Centro de salud</span></div>"
        when 'Tercer nivel de atención'
          res += "<div class='tag hospital'>#{svg('hospital.svg')}<span>Hospital</span></div>"
        end
      end
      if @site.geo_entities.present?
        res += "<div class='tag vac'>#{svg('vacunatorio.svg')}<span>Vaunatorio</span></div>"
      end
      emergency = @site.site_data.where(datum_id: @emergency_id)
      if emergency.present? && emergency
        res += "<div class='tag emergency'>#{svg('emergency.svg')}<span>Puerta de emergencia</span></div>"
      end
    when 'address'
      geo = @site.zone.parents
      geo.keys.reverse_each do |zkey|
        res += "<div class='tag location'>#{svg('location-pin.svg')}<span>#{geo[zkey].name}</span></div>"
      end
      res += self.site_address
    end
    res.html_safe
  end

  def site_address
    addrs = []
    ['address', 'address_comp', 'highway', 'highway_km'].each do |addr|
      addrs.push(@site[addr]) if @site[addr].present? 
    end
    "<div class='address column'><b>Dirección</b><span>#{addrs.join(', ')}</span></div>".html_safe
  end
end