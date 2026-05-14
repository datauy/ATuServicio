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
    sites('policlinicas-ASSE.csv', "Primer nivel de atención", [p])
    #sites('sedes.csv')
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
        metadata['sites']["columns"].each do |key|
          data = Datum.find_or_create_by({
            key: key,
            title: metadata['sites']["description"][i]
          })
          data.update(dtype: metadata['sites']["definition"][key].first, is_active: true)
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
        name = row['name'].remove("\t")
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
      if (row['tipo'].present? || asse) && (p.present? || row['prestador']) && row['estado etapa'] != 'pendiente' && row['departamen'].present?
        puts "SITES START #{row['nombre']}"
        #get State
        state = Zone.search(row['departamen'], "Departamento")
        #get prestador
        if p.nil?
          p = Provider.search( I18n.transliterate(row['prestador']) )
        end
        if state.empty? || p.empty?
          puts "DEPTO #{row['departament']} O PROVIDER #{row['prestador']} NO ENCONTRADO "
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
        provider = p.first
        #Get Point
        point = Zone.find_or_create_by({
          name: "#{provider.name} - #{row['nombre']}",
          ztype: "Punto",
          parent_zone_id: parent_id,
          wkt: "POINT (#{row['lon']}, #{row['lat']})"
        })
        s = Site.find_or_create_by({
          provider: provider,
          zone: point,
          name: row['nombre'],
          description: row['desc'],
          stype: row['tipo'],
          state: state,
          address: row['calle'],
          address_comp: row['calle_nro'],
          highway: row['ruta'],
          highway_km: row['km'],
        })
        puts "Site Created: #{row['nombre_del_establecimiento']}"
        level = row['nivel'].present? ? row['nivel'] : level
        if (!asse)
          #get site data
          metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml")).to_h
          metadata['sites']['columns'].each do |key|
            #get Datum
            d = Datum.find_by(key: key)
            #Check data type
            value = row['key']
            text = ''
            case d.dtype
            when 'boolean'
              if row['key'].downcase == 'si'
                value = 1
              end
              if row['key'].downcase == 'no'
                value = 0
              end
            when 'array'
              text = row['key']
              value = 0
            end
            if d.present?
              SiteDatum.find_or_create_by({
                datum: d,
                site: s,
                level: level,
                year: @year,
                period: @period,
                value: value,
                text: text,
              })
            else
              puts "DATUM NOT FOUND"
            end
          end
        else
          puts "CREATE EMPTY DATUM"
          SiteDatum.find_or_create_by({
            site: s,
            level: level,
            year: @year,
            period: @period,
          })
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
