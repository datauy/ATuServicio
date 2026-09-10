require 'csv'

namespace :importer do
  @year = '2026'
  @period = '1'
  @strict = true

  #TODO: set as default function before task
  def set_env(args)
    if args[:year].present?
      @year = args[:year]
    end
    if args[:period].present?
      @period = args[:period]
    end
    puts "AÑO - PERIODO: #{@year} - #{@period}"
  end
  def conciliate_site_categories
    Site.where(category: nil).each do |s|
      category = 'POLICLINICA'
      s.levels.each do |level|
        case level
        when 'Segundo nivel de atención'
          category = 'CENTRO DE SALUD'
        when 'Tercer nivel de atención'
          category = 'HOSPITAL'
        end
      end
      puts "UPDATE"
      s.update(category: category)
    end
  end

  def conciliate_asse_vacs
    pp = '[{"id":139,"name":"CENTRO DE SALUD CIUDAD DE LA COSTA","description":null,"address":"AVDA. GARCIA AROCENA"},{"id":162,"name":"POLICLINICA ZAPICAN","description":null,"address":null},{"id":147,"name":"CENTRO AUXILIAR TALA","description":null,"address":"J
OSE J ALONSO Y TRELLES"},{"id":155,"name":"POLICLINICA COLONIA VALDENSE","description":null,"address":"11 DE JUNIO"},{"id":158,"name":"POLICLINICA CASUPA","description":null,"address":"JOSE PEDRO VARELA"},{"id":164,"name":"POLICLINICA PIRIAPOLIS","description":null,"addre
ss":"SIMON DEL PINO"},{"id":186,"name":"HOSPITAL PASTEUR","description":"HOSPITAL PASTEUR","address":"LARRAVIDE"},{"id":168,"name":"CENTRO DE SALUD J ROYOL","description":null,"address":"DR. ALTIVO ESTEVES"},{"id":178,"name":"POLICLINICA UBA 3","description":null,"address
":null},{"id":180,"name":"CENTRO DEPARTAMENTAL SALTO","description":"HOSPITAL DE SALTO","address":"CERVANTES SAAVEDRA"},{"id":181,"name":"POLICLINICA VILLA CONSTITUCION","description":null,"address":"G OXANDABARAT"},{"id":182,"name":"CENTRO DE SALUD CIUDAD VIEJA","descrip
tion":null,"address":"25 DE MAYO"},{"id":183,"name":"CENTRO DE SALUD PIEDRAS BLANCAS ANEXO","description":null,"address":"AVDA. JOSE BELLONI"},{"id":184,"name":"HOSPITAL PEDIATRICO","description":null,"address":"BVAR. GRAL. ARTIGAS"},{"id":212,"name":"POLICLINICA CHARQUEA
DA","description":null,"address":null},{"id":216,"name":"CENTRO AUXILIAR VERGARA","description":null,"address":"CNEL. M BARRETO"},{"id":226,"name":"POLICLINICA SANTA ROSA","description":null,"address":"18 DE JULIO"},{"id":227,"name":"POLICLINICA SAN BAUTISTA","description
":null,"address":"JUSTO ALVAREZ"},{"id":229,"name":"POLICLINICA CASARINO","description":null,"address":null},{"id":231,"name":"POLICLINICA FLORESTA BALNEARIO","description":null,"address":"RBLA. DR. PEREA"},{"id":232,"name":"POLICLINICA SALINAS","description":null,"addres
s":"AVDA. JULIETA"},{"id":240,"name":"POLICLINICA AUTODROMO","description":null,"address":"RIO NEGRO"},{"id":241,"name":"POLICLINICA PINAR","description":null,"address":"GUILLERMO PEREZ BUTLER"},{"id":245,"name":"CENTRO DE SALUD MONTERREY","description":null,"address":"FR
ANCISCO MACIEL"},{"id":247,"name":"POLICLINICA VILLA DON ARTURO","description":null,"address":"CMNO. AL PASO ESCOBAR"},{"id":248,"name":"CENTRO AUXILIAR DOLORES","description":"CENTRO AUXILIAR DOLORES","address":"ANDRES CHEVESTE"},{"id":249,"name":"POLICLINICA AGRACIADA",
"description":null,"address":null},{"id":251,"name":"POLICLINICA CARLOS REYLES","description":null,"address":"RIVERA"},{"id":318,"name":"POLICLINICA PASO PEREIRA","description":null,"address":null},{"id":259,"name":"POLICLINICA CANADA NIETO","description":null,"address":n
ull},{"id":260,"name":"POLICLINICA VILLA PANCHA","description":null,"address":null},{"id":261,"name":"POLICLINICA EGANA","description":null,"address":"TABARE"},{"id":263,"name":"POLICLINICA BARRIO KENNEDY","description":null,"address":"RINCON"},{"id":264,"name":"POLICLINI
CA BARRIO HIPODROMO","description":null,"address":null},{"id":265,"name":"POLICLINICA LA CAPUERA","description":null,"address":null},{"id":268,"name":"POLICLINICA PUNTA DEL DIABLO","description":null,"address":null},{"id":269,"name":"POLICLINICA CEBOLLATI","description":n
ull,"address":"SAN MIGUEL"},{"id":270,"name":"POLICLINICA LA PALOMA","description":null,"address":null},{"id":273,"name":"POLICLINICA LA CORONILLA","description":null,"address":null},{"id":274,"name":"POLICLINICA SAN LUIS","description":null,"address":"MISIONES"},{"id":27
8,"name":"POLICLINICA JOSE ENRIQUE RODO","description":null,"address":"RUTA 2 GRITO DE ASENCIO"},{"id":279,"name":"POLICLINICA PALMITAS","description":null,"address":"LAURENA JAUREGUI"},{"id":282,"name":"POLICLINICA RISSO","description":null,"address":null},{"id":283,"nam
e":"POLICLINICA VILLA SORIANO","description":null,"address":null},{"id":280,"name":"POLICLINICA PALMAR","description":null,"address":"BRASIL"},{"id":275,"name":"POLICLINICA 18 DE JULIO","description":null,"address":null},{"id":287,"name":"POLICLINICA VELAZQUEZ","descripti
on":null,"address":null},{"id":288,"name":"POLICLINICA LOS CERRILLOS","description":null,"address":null},{"id":289,"name":"CENTRO DE SALUD PARQUE DEL PLATA","description":null,"address":"TOMAS BERRETA"},{"id":291,"name":"POLICLINICA CONCHILLAS","description":null,"address
":"DAVID EVANS"},{"id":292,"name":"POLICLINICA CUFRE","description":null,"address":"SARANDI"},{"id":298,"name":"POLICLINICA CARDAL","description":null,"address":"AVDA. GRAL. ARTIGAS"},{"id":299,"name":"POLICLINICA CERRO COLORADO","description":null,"address":null},{"id":3
00,"name":"POLICLINICA CHAMIZO","description":null,"address":"FLORIDA"},{"id":301,"name":"POLICLINICA FRAY MARCOS","description":null,"address":null},{"id":302,"name":"POLICLINICA INDEPENDENCIA","description":null,"address":null},{"id":303,"name":"POLICLINICA 25 DE MAYO",
"description":null,"address":"19 DE JUNIO"},{"id":304,"name":"POLICLINICA 25 DE AGOSTO","description":null,"address":"MANUEL CALLEROS"},{"id":305,"name":"POLICLINICA GONI","description":null,"address":"SARANDI"},{"id":306,"name":"POLICLINICA LA CRUZ","description":null,"a
ddress":null},{"id":307,"name":"POLICLINICA POLANCO DEL YI","description":null,"address":"RUTA 42"},{"id":308,"name":"POLICLINICA MENDOZA GRANDE","description":null,"address":null},{"id":310,"name":"POLICLINICA ANDRESITO","description":null,"address":"SENAQUE"},{"id":311,
"name":"POLICLINICA ISMAEL CORTINAS","description":null,"address":"LUIS A DE HERRERA"},{"id":314,"name":"POLICLINICA CUCHILLA ALTA","description":null,"address":"MONTEVIDEO"},{"id":316,"name":"POLICLINICA AREVALO","description":null,"address":null},{"id":321,"name":"POLIC
LINICA CERRO DE LAS CUENTAS","description":null,"address":null},{"id":322,"name":"POLICLINICA CUCHILLA GRANDE","description":null,"address":null},{"id":323,"name":"POLICLINICA RAMON TRIGO","description":null,"address":null},{"id":329,"name":"POLICLINICA ESTACION ATLANTIDA
","description":null,"address":null},{"id":330,"name":"POLICLINICA ESTACION FLORESTA","description":null,"address":null},{"id":331,"name":"CENTRO DE SALUD LA CRUZ DE CARRASCO","description":null,"address":"JUAN AGAZZI"},{"id":342,"name":"POLICLINICA YANICELLI","descriptio
n":null,"address":null},{"id":332,"name":"CENTRO DEPARTAMENTAL DURAZNO","description":"HOSPITAL DE DURAZNO","address":"DR. MIGUEL C RUBINO"},{"id":233,"name":"POLICLINICA PARQUE DEL PLATA NORTE","description":null,"address":null},{"id":354,"name":"POLICLINICA INVE 16","de
scription":null,"address":"HIPOLITO YRIGOYEN"},{"id":351,"name":"CENTRO AUXILIAR SAN RAMON","description":null,"address":null},{"id":347,"name":"POLICLINICA ALBISU","description":null,"address":null},{"id":317,"name":"POLICLINICA TRES ISLAS","description":null,"address":n
ull}]'
    jj = JSON.parse(pp)
    jj.each do |site|
      s = Site.find_by(name: site['name'])
      if s.present?
        puts "UPDATING #{s['name']}"
        GeoEntity.find(site['id']).update(site_id: s['id'])
      else
        puts "NOT FOUND: #{site['name']}"
      end
    end
  end
  #
  # Create providers
  #
  desc 'Importing providers'
  task :providers, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    providers
  end

  task :specialists, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    specialists()
  end
  task :prices, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    prices()
  end
  task :rrhh, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    rrhh()
  end
  task :cad, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    rrhh_cad()
  end
  task :goals, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    goals()
  end
  task :sites, [:year, :period, :asse] => [:environment] do |_, args|
    set_env(args)
    p = Provider.find(9000)
    #sites('hospitales-ASSE.csv', "Tercer nivel de atención", [p])
    #sites('centros-salud-ASSE.csv', "Segundo nivel de atención", [p])
    #sites('policlinicas-ASSE.csv', "Primer nivel de atención", [p])
    sites('sedes-asse.csv', nil, p)
  end

  task :metadata, [:mtype] => [:environment] do |_, args|
    metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml")).to_h
    metadata.keys.each do |key|
      case key
      when 'stalled'#'precios'
        puts "IMPORT PRICES"
        i = 0
        metadata['precios']["description"].each do |desc|
          desc_arr = desc.split('. FONAS')
          if desc_arr.length > 1
            price = {
              name: desc_arr[0]
            }
            col = metadata['precios']['columns'][i]
            metadata['precios']['averages_fonasa'].keys.each do |avg|
              if metadata['precios']['averages_fonasa'][avg]['columns'].include? col
                price[:ptype] = avg
              end
            end
            #puts "Adding #{metadata['precios']['averages_fonasa'][avg]['columns'].inspect}"
            puts "Adding #{price.inspect}"
            Price.find_or_create_by(price)
          end
          i += 1
        end
      when 'stall' #'rrhh', 'rrhh_cad', 'goals'
        puts "IMPORT INDICATOR #{key}"
        i = 0
        section = Section.find_by(name: key)
        if section.present?
          metadata[key]["description"].each do |desc|
            title = metadata[key]["titles"].present? ? metadata[key]["titles"][i] : metadata[key]['abbrs'][i]
            ind = {
              title: title,
              description: desc,
              abbr: metadata[key]['abbrs'][i],
              active: true,
              section_id: section.id,
              weight: i
            }
            Indicator.find_or_create_by(ind)
            puts "ADDING Indicator #{ind.inspect}"
            i += 1
          end
        else
          puts "Section NOT FOUND: #{key}"
        end
      when 'sites'
        i = 0
        metadata['sites']["columns"].each do |skeys|
          puts "SITES META: #{skeys}"
          found = false
          datum = nil
          skeys.split(',').each do |key|
            datum = Datum.find_by( key: key )
            if datum.present?
              found = true
              break
            end
          end
          if found 
            datum.update(
              dtype: metadata['sites']["definition"][skeys].first,
              is_active: true,
              key: skeys
            )
          else
            datum = Datum.create({
              key: skeys,
              title: metadata['sites']["description"][i],
              dtype: metadata['sites']["definition"][skeys].first,
              is_active: true,
            })
          end
          i += 1
        end
      end
    end
  end
  #
  task :geo, [:file, :gtype] => [:environment] do |_, args|
    file = 'vacunatorios.csv'
    gtype = 'vacunatorio'
    if args[:file].present?
      file = args[:file]
    end
    if args[:gtype].present?
      gtype = args[:gtype]
    end
    # TODO: add state to vacunatorios and others
    import_file(file) do |row|
      if row["WKT"].present? && row['name'].present?
        name = row['name'].strip.split("\t")[-1]
        z = {
          wkt: row["WKT"],
          name: name,
          ztype: 'Punto'
        }
        zone = Zone.find_or_create_by(z)
        geo = GeoEntity.find_or_create_by({
          zone: zone,
          gtype: gtype,
          name: name,
        })
        geo.update(is_active: true, description: row['description'])
      end
    end
  end
  #
  def sites(file, level = nil, p = nil)
    asse = false
    if p.present?
      asse = true
    end
    import_file(file) do |row|
      a = (row['tipo'].present? || asse)
      b = (p.present? || row['prestador'])
      c = (row['estado etapa'].nil? || row['estado etapa'] != 'pendiente')
      d = row['departamento'].present?
      puts "START IMPORT SITES #{a} O PROVIDER #{row['nombre']} "
      if (row['tipo'].present? || asse) && (p.present? || row['prestador']) && (row['estado etapa'].nil? || row['estado etapa'] != 'pendiente') && row['departamento'].present?
        #get State
        state = Zone.search(row['departamento'], "Departamento")
        #get prestador
        if p.nil?
          provider = Provider.search( row['prestador'] ).first
        else
          provider = p
        end
        if state.empty? || provider.nil?
          puts "DEPTO #{row['departamento']} O PROVIDER #{row['prestador']} NO ENCONTRADO "
          next
        end
        parent_id = state.first.id
        if row['localidad'].present?
          #Get Location
          location = Zone.search(row['localidad'], "Localidad")
          if location.empty?
            location = Zone.create({
              name: row['localidad'],
              ztype: "Localidad",
              parent_zone_id: parent_id
            })
          else
            location = location.first
          end
          parent_id = location.id
        end
        #Get Point
        wkt = row['geometry'].present? ? row['geometry'] : "POINT (#{row['lon']}, #{row['lat']})"
        point = Zone.find_or_create_by({
          name: "#{provider.name} - #{row['nombre']}",
          ztype: "Punto",
          parent_zone_id: parent_id,
          wkt: wkt
        })
        level = row['nivel'].present? ? row['nivel'] : row['nivelatencion'].present? ? "#{row['nivelatencion'].downcase.capitalize} de atención" : level
        category = 'POLICLINICA'
        if row['categoria'].present?
          category = row['categoria']
        else
          case level
          when 'Segundo nivel de atención'
            category = 'CENTRO DE SALUD'
          when 'Tercer nivel de atención'
            category = 'HOSPITAL'
          end
        end

        s = Site.find_or_create_by({
          provider: provider,
          zone: point,
          name: row['nombre'],
          description: row['desc'].present? ? row['desc'] : row['alias'],
          category: category,
          stype: row['tipo'],
          state: state.first,
          address: row['calle'],
          address_comp: row['calle_nro'].present? ? row['calle_nro'] : row['numpuerta'],
          highway: row['ruta'],
          highway_km: row['km'],
        })
        #get site data
        metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml")).to_h
        metadata['sites']['columns'].each do |key|
          #get Datum
          d = Datum.find_by(key: key)
          if d.present?
            key.split(',').each do |k|
              value = row[k]
              if value.present?
                text = ''
                #Check data type
                case d.dtype
                when 'boolean'
                  if row[k].downcase == 'si'
                    value = 1
                  end
                  if row[k].downcase == 'no'
                    value = 0
                  end
                when 'array'
                  text = row[k]
                  value = 0
                end
                SiteDatum.find_or_create_by({
                  datum: d,
                  site: s,
                  level: level,
                  year: @year,
                  period: @period,
                  value: value,
                  text: text,
                })
                break
              end
            end
          else
            puts "DATUM NOT FOUND"
          end
        end
      end
    end
  end
  #
  def providers
    puts 'Creating or updating providers'
    provider_ids = []
    import_file("estructura.csv") do |row|
      provider = Provider.find_or_create_by( id: row[0] )
      provider_ids.push(row[0])
      provider.update(
        short_name: row[1].strip,
        name: row[2].strip,
        web: row[3],
        #logo: assign_logo(row[0]),
        communication: row[7],
        active: true,
        #servicios_atencion_adolescentes: row[9],
        private_insurance: row[1].include?('Seguro Privado') ? true : nil
      )
      #puts "Provider updated #{@year} - #{@period} (#{ provider->id }): #{provider->nombre_abreviado}"
      #Check no record exists
      pd = ProviderDatum.where(provider_id: provider.id, year: @year, period: @period)
      if pd.empty?
        ProviderDatum.create(provider_id: provider.id, year: @year, period: @period, fonasa_users: row[4], no_fonasa_users: row[5], total:row[6] )
      else
        #TODO: record change
      end
    end
    to_deactivate = Provider.where.not(id: provider_ids)
    puts "\nDEACTIVATING #{to_deactivate.map(&:id).inspect}\n\n\n"
    to_deactivate.update(active: false)
  end


  # Import prices
  #
  def prices()
    puts 'Import Prices'
    import_file("precios.csv") do |row|
      #provider = Provider.find(row['id_mutualista'])
      Price.all.each do |p|
        npp = {
          price_id: p.id,
          provider_id: row['id_mutualista'],
          period: @period,
          year: @year,
          fonasa: true
        }
        value = row["#{p.name}. FONASA".upcase]
        if value.present?
          pp = ProviderPrice.find_or_create_by(npp)
          pp.update(value: value)
        end
        value = row["#{p.name}. NO FONASA".upcase]
        if value.present?
          npp[:fonasa] = false
          pp = ProviderPrice.find_or_create_by(npp)
          pp.update(value: value)
        end
        puts "Import PRICES #{p.name} for provider: #{row['id_mutualista']}" 
      end 
    end
  end
  #
  # Import specialists
  #
  def specialists()
    import_file("rrhh_especialistas.csv") do |row|
      speciality = Speciality.find_or_create_by( name: row["specialty"] )
      state = nil;
      if ( row["state"] != 'total país')
        state = Zone.find_or_create_by(name: row["state"], ztype: "Departamento")
      else
        state = Zone.find_or_create_by(name: 'Uruguay', ztype: "País")
      end
      if row['indicator_value'] == 's/d'
        row['indicator_value'] = nil
      end
      provider = Provider.find_by(short_name: row['provider'] )
      provider = Provider.find_by(short_name: "#{row['provider']} IAMPP" ) if provider.nil?
      if provider.nil?
        puts "PROVIDER NOT FOUND: #{row['provider']}"
        next
      else
        sp = {
          provider: provider,
          speciality_id: speciality.id,
          zone: state,
          year: @year,
          period: @period
        }
        specialist = ProviderSpecialist.find_or_create_by(sp)
        puts "Import Specialists HR #{specialist.inspect}"
        specialist.update(value: row['indicator_value'])
      end
    end
  end

  def rrhh()
    puts 'Import RRHH'
    sec = Section.find_by(name: 'rrhh')
    if sec.present?
      import_file("rrhh_general.csv") do |row|
        cads = Indicator.where(section_id: sec.id, active: true, abbr: row['indicator'])
        create_indicator(row, cads)
      end
    end
  end

  def rrhh_cad()
    puts 'Import RRHH CAD'
    sec = Section.find_by(name: 'rrhh_cad')
    if sec.present?
      cads = Indicator.where(section_id: sec.id, active: true)
      import_file("rrhh_cad.csv") do |row|
        create_indicator(row, cads)
      end
    end
  end

  def goals()
    puts 'Import METAS'
    sec = Section.find_by(name: 'goals')
    if sec.present?
      cads = Indicator.where(section_id: sec.id, active: true)
      import_file("metas.csv") do |row|
        create_indicator(row, cads)
      end
    end
  end

  def create_indicator(row, indicators)
    row_prov_is_numeric = Float(row['provider']) != nil rescue false
    if row_prov_is_numeric
      provider = Provider.find( row['provider'] )
    else
      provider = Provider.find_by(short_name: row['provider'] )
      provider = Provider.find_by(short_name: "#{row['provider']} IAMPP" ) if provider.nil?
    end
    if provider.nil?
      puts "PROVIDER NOT FOUND: #{row['provider']}"
      return
    else
      puts "Creating INDICATOR for #{provider.short_name}"
      if ( row["state"].present? && row["state"] != 'total país')
        state = Zone.find_or_create_by(name: row["state"], ztype: "Departamento")
      else
        state = Zone.find_or_create_by(name: 'Uruguay', ztype: "País")
      end
      indicators.each do |indi|
        pi = {
          year: @year,
          period: @period,
          indicator: indi,
          provider: provider,
          zone_id: state.id
        }
        #puts "Creating CAD #{pi.inspect}"
        pindicator = ProviderIndicator.find_or_create_by(pi)
        if row[indi.abbr].present?
          value = row[indi.abbr]
        else
          value = row['indicator_value']
        end
        if value == 'Si' || value == true
          value = 1
        elsif value == 'No' || value ==   false
          value = 0
        end
        pindicator.update(value: value)
      end
    end
  end
  #
  def import_file(file, &block)
    options = {headers: true}
    #options.merge!(custom_options) if custom_options
    f = File.join(Rails.root, "db/data/", @period ? "#{@year}-#{@period}" : @year, file)
    puts "IMPORTING #{options.inspect}"
    CSV.foreach(f, headers: true, col_sep: ';') do |row|
      yield row
    end
  end

end
