require 'csv'

namespace :importer do
  @year = '2025'
  @period = '1'
  @strict = true
  #
  # Create providers
  #
  desc 'Importing providers'
  task :providers, [:year] => [:environment] do |_, args|
    providers
  end

  task :wait_time, [:year] => [:environment] do |_, args|
    wait_time
  end

  task :metadata, [:mtype] => [:environment] do |_, args|
    metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml")).to_h
    metadata.keys.each do |key|
      case key
      when 'metas':

      when 'precios':

      when 'tiempos_espera':

      when 'rrhh':

      end
    end
  end


  def providers
    puts 'Creating or updating providers'
    provider_ids = []
    import_file("#{@year + (@period ? '-'+@period : '')}/estructura.csv", col_sep: ';') do |row|
      provider = Provider.find_or_create_by( id: row[0] )
      provider_ids.push(row[0])
      provider.update(
        short_name: row[1],
        name: row[2],
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

  #
  # Import wait times
  #
  def wait_times(file)
    puts 'Import Specialists'
    last_provider = ""
    import_file("#{@year + (@stage ? '-'+@stage : '')}/#{file}", col_sep: ';') do |row|
      #TODO: Are we importing this?
    end
  end
  #
  # Import prices
  #
  def prices(file)
    puts 'Import Prices'
    last_provider = ""
    import_file("#{@year + (@stage ? '-'+@stage : '')}/#{file}", col_sep: ';') do |row|
      #TODO: Are we importing this?
    end
  end
  #
  # Import specialists
  #
  def specialists(file)
    puts 'Import Specialists'
    last_provider = ""
    import_file("#{@year + (@stage ? '-'+@stage : '')}/#{file}", col_sep: ';') do |row|
      specialist = Specialist.find_or_create_by( title: row["specialty"] )
      if ( row["state"] == 'total país')
        row["state"] = nil;
      end
      if row['indicator_value'] == 's/d'
        row['indicator_value'] = nil
      end
      if last_provider != row['provider']
        last_provider = row['provider']
        puts "Specialists for #{last_provider}"
      end
      create_providerRelation(row['provider'], row['indicator_value'], row["state"], specialist.id)
      activateIndicator(specialist.id, "specialist_id")
    end
  end

  def import_file(file, custom_options = nil, &block)
    options = {headers: true}
    #options.merge!(custom_options) if custom_options
    f = File.join(Rails.root, "db/data/", file)
    puts "IMPORTING #{options.inspect}"
    CSV.foreach(f, headers: true, col_sep: ';') do |row|
      yield row
    end
  end

end
