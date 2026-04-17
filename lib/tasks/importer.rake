require 'csv'

namespace :importer do
  @year = '2025'
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

  task :metadata, [:mtype] => [:environment] do |_, args|
    metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml")).to_h
    metadata.keys.each do |key|
      case key
      when 'precios'
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
      when 'rrhh', 'rrhh_cad', 'goals'
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
      end
    end
  end

  def providers
    puts 'Creating or updating providers'
    provider_ids = []
    import_file("estructura.csv", col_sep: ';') do |row|
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
    import_file("precios.csv", col_sep: ';') do |row|
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
    import_file("rrhh_especialistas.csv", col_sep: ';') do |row|
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
      import_file("rrhh_general.csv", col_sep: ';') do |row|
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
      import_file("rrhh_cad.csv", col_sep: ';') do |row|
        create_indicator(row, cads)
      end
    end
  end

  def goals()
    puts 'Import METAS'
    sec = Section.find_by(name: 'goals')
    if sec.present?
      cads = Indicator.where(section_id: sec.id, active: true)
      import_file("metas.csv", col_sep: ';') do |row|
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
  def import_file(file, custom_options = nil, &block)
    options = {headers: true}
    #options.merge!(custom_options) if custom_options
    f = File.join(Rails.root, "db/data/", @period ? "#{@year}-#{@period}" : @year, file)
    puts "IMPORTING #{options.inspect}"
    CSV.foreach(f, headers: true, col_sep: ';') do |row|
      yield row
    end
  end

end
