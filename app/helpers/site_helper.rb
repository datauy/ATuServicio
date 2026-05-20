module SiteHelper

  def get_site_tags(ttype)
    res = ''
    case ttype
    when 'level'
      @site.site_data.pluck(:level).uniq.each do |level|
        case level
        when 'Primer nivel de atención'
          res += '<div class="tag"><i class="fas fa-stethoscope"></i><span>Policlínica</span></div>'
        when 'Segundo nivel de atención'
          res += '<div class="tag"><img src="/images/housemedical.svg"></i><span>Centros de salud</span></div>'
        when 'Tercer nivel de atención'
          res += '<div class="tag"><img src="/images/hospital.svg"></i><span>Hospitales</span></div>'
        end
      end
    when 'address'
      geo = @site.zone.parents
      geo.keys.reverse_each do |zkey|
        res += "<div class='tag location'><img src='/images/user.svg'></i><span>#{geo[zkey].name}</span></div>"
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
    "<div class='address tag'>#{addrs.join('</div><div class="address tag">')}</div>".html_safe
  end
end