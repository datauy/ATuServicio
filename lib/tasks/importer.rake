require 'csv'

namespace :importer do
  @year = '2026'
  @period = '2'
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

  def conciliate_vacs
    pp = [{"id" => 314, "provider_id" => 769, "name" => "POLICLINICA CUCHILLA ALTA", "address" => "CALLE 16 S/N CUCHILLA ALTA"},
    {"id" => 366, "provider_id" => 7618, "name" => "POLICLINICO CASTILLOS", "address" => "FORMOSO"},
    {"id" => 300, "provider_id" => 6618, "name" => "POLICLINICA CHAMIZO", "address" => "25 DE AGOSTO"},
    {"id" => 304, "provider_id" => 6618, "name" => "POLICLINICA 25 DE AGOSTO", "address" => "BRUNO MAS"},
    {"id" => 298, "provider_id" => 6618, "name" => "POLICLINICA CARDAL", "address" => "RODO"},
    {"id" => 158, "provider_id" => 6618, "name" => "POLICLINICA CASUPA", "address" => "BATLLE"},
    {"id" => 301, "provider_id" => 6618, "name" => "POLICLINICA FRAY MARCOS", "address" => "ARTIGAS"},
    {"id" => 303, "provider_id" => 6618, "name" => "POLICLINICA 25 DE MAYO", "address" => "OTILIA ROLIN DE MARINONI"},
    {"id" => 331, "provider_id" => 9000, "name" => "CENTRO DE SALUD LA CRUZ DE CARRASCO", "address" => "JUAN AGAZZI"},
    {"id" => 182, "provider_id" => 9000, "name" => "CENTRO DE SALUD CIUDAD VIEJA", "address" => "25 DE MAYO"},
    {"id" => 186, "provider_id" => 9000, "name" => "HOSPITAL PASTEUR", "address" => "LARRAVIDE"},
    {"id" => 184, "provider_id" => 9000, "name" => "HOSPITAL PEDIATRICO", "address" => "BVAR. ARTIGAS"},
    {"id" => 342, "provider_id" => 9000, "name" => "POLICLINICA YANICELLI", "address" => "CNO. CARRASCO EUSKALERRIA 92"},
    {"id" => 351, "provider_id" => 9000, "name" => "CENTRO AUXILIAR SAN RAMON", "address" => "BATLLE Y ORDONEZ"},
    {"id" => 245, "provider_id" => 9000, "name" => "CENTRO DE SALUD MONTERREY", "address" => "GRAL. SAN MARTIN"},
    {"id" => 226, "provider_id" => 9000, "name" => "POLICLINICA SANTA ROSA", "address" => "18 DE JULIO"},
    {"id" => 147, "provider_id" => 9000, "name" => "CENTRO AUXILIAR TALA", "address" => "J. ALONSO Y TRELLES"},
    {"id" => 229, "provider_id" => 9000, "name" => "POLICLINICA CASARINO", "address" => "CNO. DEL ANDALUZ"},
    {"id" => 329, "provider_id" => 9000, "name" => "POLICLINICA ESTACION ATLANTIDA", "address" => "CNO. A PARQUE DEL PLATA"},
    {"id" => 288, "provider_id" => 9000, "name" => "POLICLINICA LOS CERRILLOS", "address" => "RUTA 36 KM"},
    {"id" => 289, "provider_id" => 9000, "name" => "CENTRO DE SALUD PARQUE DEL PLATA", "address" => "DIAGONAL 11"},
    {"id" => 233, "provider_id" => 9000, "name" => "POLICLINICA PARQUE DEL PLATA NORTE", "address" => "CALLE W"},
    {"id" => 227, "provider_id" => 9000, "name" => "POLICLINICA SAN BAUTISTA", "address" => "JUSTO ALVAREZ"},
    {"id" => 231, "provider_id" => 9000, "name" => "POLICLINICA FLORESTA BALNEARIO", "address" => "RAMBLA PEREA"},
    {"id" => 330, "provider_id" => 9000, "name" => "POLICLINICA ESTACION FLORESTA", "address" => "PABLO VI"},
    {"id" => 232, "provider_id" => 9000, "name" => "POLICLINICA SALINAS", "address" => "AVDA. JULIETA"},
    {"id" => 139, "provider_id" => 9000, "name" => "CENTRO DE SALUD CIUDAD DE LA COSTA", "address" => "GARCIA AROCENA"},
    {"id" => 247, "provider_id" => 9000, "name" => "POLICLINICA VILLA DON ARTURO", "address" => "CNO. A PASO ESCOBAR"},
    {"id" => 241, "provider_id" => 9000, "name" => "POLICLINICA PINAR", "address" => "AVDA. EDUARDO PEREZ"},
    {"id" => 240, "provider_id" => 9000, "name" => "POLICLINICA AUTODROMO", "address" => "INTERLAGOS"},
    {"id" => 274, "provider_id" => 9000, "name" => "POLICLINICA SAN LUIS", "address" => "JUAN CARUSO"},
    {"id" => 270, "provider_id" => 9000, "name" => "POLICLINICA LA PALOMA", "address" => "CNO. LA CAPILLA"},
    {"id" => 321, "provider_id" => 9000, "name" => "POLICLINICA CERRO DE LAS CUENTAS", "address" => "RUTA 7  KM 339"},
    {"id" => 264, "provider_id" => 9000, "name" => "POLICLINICA BARRIO HIPODROMO", "address" => "ROMEO POGGIOLA"},
    {"id" => 317, "provider_id" => 9000, "name" => "POLICLINICA TRES ISLAS", "address" => "RUTA 7  KM 346"},
    {"id" => 322, "provider_id" => 9000, "name" => "POLICLINICA CUCHILLA GRANDE", "address" => "S-D"},
    {"id" => 318, "provider_id" => 9000, "name" => "POLICLINICA PASO PEREIRA", "address" => "RUTA 7  KM 293  EMPALME A AREVALO A 75KM"},
    {"id" => 316, "provider_id" => 9000, "name" => "POLICLINICA AREVALO", "address" => "RUTA 7  KM 293 EMPALME A AREVALO 35KM"},
    {"id" => 323, "provider_id" => 9000, "name" => "POLICLINICA RAMON TRIGO", "address" => "RUTA 26  KM 396 ENTRANDO A RUTA 44"},
    {"id" => 260, "provider_id" => 9000, "name" => "POLICLINICA VILLA PANCHA", "address" => "ZELMAR MICHELINI"},
    {"id" => 155, "provider_id" => 9000, "name" => "POLICLINICA COLONIA VALDENSE", "address" => "ALICE RIVOIR DE ARMAND UGON"},
    {"id" => 291, "provider_id" => 9000, "name" => "POLICLINICA CONCHILLAS", "address" => "DAVID EVANS"},
    {"id" => 292, "provider_id" => 9000, "name" => "POLICLINICA CUFRE", "address" => "SARANDI"},
    {"id" => 332, "provider_id" => 9000, "name" => "CENTRO DEPARTAMENTAL DURAZNO", "address" => "PROF. M. RUBINO"},
    {"id" => 251, "provider_id" => 9000, "name" => "POLICLINICA CARLOS REYLES", "address" => "RIVERA"},
    {"id" => 311, "provider_id" => 9000, "name" => "POLICLINICA ISMAEL CORTINAS", "address" => "LUIS A. DE HERRERA"},
    {"id" => 310, "provider_id" => 9000, "name" => "POLICLINICA ANDRESITO", "address" => "SENAQUE"},
    {"id" => 299, "provider_id" => 9000, "name" => "POLICLINICA CERRO COLORADO", "address" => "RUTA 3"},
    {"id" => 306, "provider_id" => 9000, "name" => "POLICLINICA LA CRUZ", "address" => "GRA. JOSE ARTIGAS"},
    {"id" => 305, "provider_id" => 9000, "name" => "POLICLINICA GONI", "address" => "SARANDI"},
    {"id" => 308, "provider_id" => 9000, "name" => "POLICLINICA MENDOZA GRANDE", "address" => "FLORIDA"},
    {"id" => 302, "provider_id" => 9000, "name" => "POLICLINICA INDEPENDENCIA", "address" => "CALLE 1"},
    {"id" => 307, "provider_id" => 9000, "name" => "POLICLINICA POLANCO DEL YI", "address" => "RUTA 42"},
    {"id" => 162, "provider_id" => 9000, "name" => "POLICLINICA ZAPICAN", "address" => "BVAR. CONSTITUCION"},
    {"id" => 273, "provider_id" => 9000, "name" => "POLICLINICA LA CORONILLA", "address" => "RUTA 8 BARRIO LA CORONILLA-MINAS"},
    {"id" => 265, "provider_id" => 9000, "name" => "POLICLINICA LA CAPUERA", "address" => "AVDA. DEL LAGO"},
    {"id" => 269, "provider_id" => 9000, "name" => "POLICLINICA CEBOLLATI", "address" => "SAN MIGUEL"},
    {"id" => 287, "provider_id" => 9000, "name" => "POLICLINICA VELAZQUEZ", "address" => "CALLE 14"},
    {"id" => 275, "provider_id" => 9000, "name" => "POLICLINICA 18 DE JULIO", "address" => "DR. LUCIAN CANZANI"},
    {"id" => 268, "provider_id" => 9000, "name" => "POLICLINICA PUNTA DEL DIABLO", "address" => "JOSE G. PERCHA"},
    {"id" => 180, "provider_id" => 9000, "name" => "CENTRO DEPARTAMENTAL SALTO", "address" => "CERVANTES"},
    {"id" => 178, "provider_id" => 9000, "name" => "POLICLINICA UBA 3", "address" => "LORENZO LATORRE"},
    {"id" => 181, "provider_id" => 9000, "name" => "POLICLINICA VILLA CONSTITUCION", "address" => "G. OXANDABARAT"},
    {"id" => 347, "provider_id" => 9000, "name" => "POLICLINICA ALBISU", "address" => "CALLE 1"},
    {"id" => 279, "provider_id" => 9000, "name" => "POLICLINICA PALMITAS", "address" => "VICENTE ORCOYEN"},
    {"id" => 283, "provider_id" => 9000, "name" => "POLICLINICA VILLA SORIANO", "address" => "CABILDO"},
    {"id" => 280, "provider_id" => 9000, "name" => "POLICLINICA PALMAR", "address" => "AVDA. BRASIL"},
    {"id" => 261, "provider_id" => 9000, "name" => "POLICLINICA EGANA", "address" => "TABARE"},
    {"id" => 249, "provider_id" => 9000, "name" => "POLICLINICA AGRACIADA", "address" => "GRAL. ARTIGAS"},
    {"id" => 282, "provider_id" => 9000, "name" => "POLICLINICA RISSO", "address" => "CALLE 3"},
    {"id" => 259, "provider_id" => 9000, "name" => "POLICLINICA CANADA NIETO", "address" => "MANUEL SOUTO (RUTA 96)"},
    {"id" => 263, "provider_id" => 9000, "name" => "POLICLINICA BARRIO KENNEDY", "address" => "RINCON"},
    {"id" => 216, "provider_id" => 9000, "name" => "CENTRO AUXILIAR VERGARA", "address" => "MARCELO BARRETO"},
    {"id" => 212, "provider_id" => 9000, "name" => "POLICLINICA CHARQUEADA", "address" => "JOSE ELLAURI"},
    {"id" => 354, "provider_id" => 9000, "name" => "POLICLINICA INVE 16", "address" => "HIPOLITO IRIGOYEN"}]

    pp.each do |site|
      s = Site.find_by(name: site['name'], provider_id: site['provider_id'], address: site['address'])
      if s.present?
        puts "UPDATING #{s['name']}"
        GeoEntity.find(site['id']).update(site_id: s.id)
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
  #
  task :prices, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    prices()
  end
  #
  task :rrhh_general, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    rrhh()
  end
  #
  task :rrhh, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    rrhh()
    rrhh_cad()
    specialists()
  end
  #
  task :cad, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    rrhh_cad()
  end
  #
  task :goals, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    goals()
  end
  #
  task :sites, [:year, :period, :asse] => [:environment] do |_, args|
    set_env(args)
    p = Provider.find(9000)
    #sites('hospitales-ASSE.csv', "Tercer nivel de atención", [p])
    #sites('centros-salud-ASSE.csv', "Segundo nivel de atención", [p])
    #sites('policlinicas-ASSE.csv', "Primer nivel de atención", [p])
    sites('sedes-asse.csv', nil, p)
    sites('sedes.csv')
  end
  #
  task :equipment, [:year, :period] => [:environment] do |_, args|
    set_env(args)
    equipment()
  end
  #
  task :vacs, [] => [:environment] do |_, args|
    conciliate_vacs()
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
              is_active: true,
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
        point = Zone.find_by({
          ztype: "Punto",
          parent_zone_id: parent_id,
          wkt: wkt
        })
        if point.nil?
          point = Zone.find_or_create_by({
            name: "#{provider.name} - #{row['nombre']}",
            ztype: "Punto",
            parent_zone_id: parent_id,
            wkt: wkt
          })
        end
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
        s = Site.find_by({
          provider: provider,
          zone: point,
          name: row['nombre'],
        })
        if s.nil?
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
        else
          if s.category != 'HOSPITAL'
            if s.category == 'CENTRO DE SALUD' && category == 'HOSPITAL' || s.category == 'POLICLINICA' && category != 'POLICLINICA'
              s.update(category: category)
            end
          end
        end
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
            puts "DATUM NOT FOUND #{key}"
          end
        end
      end
    end
  end
  #
  def equipment
    puts 'Creating or updating site equipment'
    @period = '1'
    import_file("equipos.csv") do |row|
      providers = Provider.search( row['prestador__etiqueta'] )
      if providers.length > 0
        p = providers.first
        sites = []
        if row['nombre_del_establecimiento'].present?
          sites = p.sites.search(row['nombre_del_establecimiento'])
          if sites.length > 1
            dsites = sites.where(stype: row['tipo_de_establecimiento__etiqueta'])
            if dsites.present?
              sites = dsites
            end
          end
        end
        sites = p.sites.where(stype: row['tipo_de_establecimiento__etiqueta']) if sites.empty?
        if sites.present?
          if sites.length > 1
            puts "MULTIPLE SITES FOR #{row['prestador__etiqueta']} FOUND: #{row['nombre_del_establecimiento']} -> #{row['tipo_de_establecimiento__etiqueta']}"
          end
          s = sites.first
        else
          puts "SITE FOR #{row['prestador__etiqueta']} NOT FOUND: #{row['nombre_del_establecimiento']}" 
        end
      else
        puts "PROVIDER NOT FOUND #{row['prestador__etiqueta']}"
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
      if row["specialty"].present? && row["specialty"] != ''
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
        provider = Provider.search( row['provider'] ).first
        provider = Provider.search( "#{row['provider']} IAMPP" ).first if provider.nil?
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
  end

  def rrhh()
    puts 'Import RRHH'
    sec = Section.find_by(name: 'rrhh')
    if sec.present?
      import_file("rrhh_general.csv") do |row|
        cads = Indicator.where(section_id: sec.id, is_active: true, abbr: row['indicator'])
        create_indicator(row, cads)
      end
    end
  end

  def rrhh_cad()
    puts 'Import RRHH CAD'
    sec = Section.find_by(name: 'rrhh_cad')
    if sec.present?
      cads = Indicator.where(section_id: sec.id, is_active: true)
      import_file("rrhh_cad.csv") do |row|
        create_indicator(row, cads)
      end
    end
  end

  def goals()
    puts 'Import METAS'
    sec = Section.find_by(name: 'goals')
    if sec.present?
      cads = Indicator.where(section_id: sec.id, is_active: true)
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
      provider = Provider.search(row['provider'] ).first
      provider = Provider.search("#{row['provider']} IAMPP" ).first if provider.nil?
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
