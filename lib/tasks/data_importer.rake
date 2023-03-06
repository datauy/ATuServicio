# See:
require "#{Rails.root}/lib/importer_helper"

include ImporterHelper

namespace :importer do
  @year = '2023'
  @stage = nil
  @strict = true
  desc 'Importing everything'
  task :all, [:year] => [:environment] do |_, args|
    @year = args[:year]
    puts "Importing all data for year #{@year}"

    Rake::Task['importer:all'].enhance do
      Rake::Task['importer:states'].invoke
    end

    pias_data
    pias_ancestry
    providers
    provider_partial_data
    sedes
    calculate_maximums
    assign_search_name
    structure
  end

  task :providers_data, [:year] => [:environment] do |_, args|
    providers
    provider_partial_data
    calculate_maximums
    assign_search_name
  end



  task :test, [:year] => [:environment] do |_, args|
    name = :precios
    importing(name, @year)
    calculate_maximums
    #puts "Re Importing RRHH General Test"
    #@strict = false
    #rrhh_general_provider('rrhh_general_pais.csv')
    #@strict = true
    #rrhh_general_provider('rrhh_general_pais_COMEF.csv')
  end
  #
  # Los departamentos se importan de config/states.yml
  #
  desc 'Import States'
  task states: [:environment] do
    puts 'Import states'
    states = YAML.load_file('config/states.yml')
    states.each do |state|
      State.find_or_create_by(
        name: state
      )
    end
  end

  #
  #
  #
  def fetch_metadata(group)
    metadata = YAML.load_file(File.join(Rails.root, "config", "metadata.yml"))
    i = 0
    metadata[group]["description"].each do |desc|
      #puts "#{metadata[args[:group]]["columns"][i]} => #{desc}}"
      Indicator.find_or_create_by(
        key: metadata[group]["columns"][i],
        description: desc
      )
      i += 1
    end
    #columns = METADATA[:precios][:averages][name][:columns]
  end
  #
  # Impport HHRR
  #
  desc 'Import All RRHH'
  task rrhh: [:environment] do
    fetch_metadata('rrhh')
    specialists
    rrhh_general
    rrhh_cad
  end
  #
  # Import specialists
  #
  def specialists
    puts 'Import Specialists'
    last_provider = ""
    import_file("#{@year + (@stage ? '-'+@stage : '')}/rrhh_especialistas-COMEF.csv", col_sep: ';') do |row|
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
    end
  end
  #
  def rrhh_general_provider(file)
    last_provider = ''
    provider = nil
    import_file("#{@year + (@stage ? '-'+@stage : '')}/#{file}", col_sep: ';') do |row|
      indicator = Indicator.find_by( abbr: row["indicator"] )
      if indicator.present?
        if last_provider != row['provider']
          puts "UPDATING PROVIDER RRHH general: #{row['provider']}"
          last_provider = row['provider']
          if @strict
            provider = Provider.find_by(nombre_abreviado: row['provider'] )
          else
            provider = Provider.where("nombre_abreviado like ?", "#{row['provider']}%" ).first
          end
          if !provider
            raise "Provider not found: #{pname}"
          end
        end
        if row['indicator_value'] == 's/d'
          row['indicator_value'] = nil
        end
        provider[indicator.key] = row['indicator_value']
        provider.save
      else
        puts "INDICADOR NO ENCONTRADO: #{row["indicator"]}"
      end
    end
  end
  #
  def rrhh_general
    puts 'Import RRHH'
    last_provider = ""
    import_file("#{@year + (@stage ? '-'+@stage : '')}/rrhh_general-COMEF.csv", col_sep: ';') do |row|
      indicator = Indicator.find_by( abbr: row["indicator"] )
      if indicator.present?
        if ( row["state"] == 'total país')
          row["state"] = nil;
        end
        if row['indicator_value'] == 's/d'
          row['indicator_value'] = nil
        end
        if last_provider != row['provider']
          last_provider = row['provider']
          puts "RRHH General for #{last_provider}"
        end
        create_providerRelation(row['provider'], row['indicator_value'], row["state"], nil, indicator.id)
        activateIndicator(indicator.id)
      else
        puts "INDICADOR NO ENCONTRADO: #{row["indicator"]}"
      end
    end
  end
  #
  def rrhh_cad
    puts 'Import RRHH CAD'
    import_file("#{@year + (@stage ? '-'+@stage : '')}/rrhh_cad-COMEF.csv", col_sep: ';') do |row|
      stage_cads = [
        ['cantidad_cad','total'],
        ['medicina_general_cantidad_cad','MG'],
        ['medicina_familiar_cantidad_cad','MFYC'],
        ['pediatria_cantidad_cad','Pediatría'],
        ['ginecotologia_cantidad_cad','Gine'],
        ['cantidad_cad_psiquiatria_adultos','Psiq A'],
        ['cantidad_cad_psiquiatria_pediatrica','Psiq P'],
        ['medicina_intensiva_adultos_nuevo_regimen','MIA'],
        ['medicina_intensiva_pediatrica_nuevo_regimen','MIP'],
        ['medicina_intensiva_neonatologia_nuevo_regimen','NEO'],
      ]
      stage_cads.each do |cad_arr|
        puts "Creating CAD for #{row['provider']}"
        i = Indicator.find_by(key: cad_arr[0])
        value = row[cad_arr[1]]
        if value == 'Si' || value == true
          value = 1
        elsif value == 'No' || value ==   false
          value = 0
        end
        create_providerRelation(row['provider'], value, nil, nil, i.id)
        activateIndicator(i.id)
      end
    end
  end

  def activateIndicator(i)
    IndicatorActive.find_or_create_by({
      indicator_id: i,
      year: @year,
      stage: @stage,
      active: true
    })
  end
  #
  def delete_providerRelations

  end
  #
  def create_providerRelation(pname, indicator_value, state_name = nil, spec_id = nil, indicator_id = nil)
    if state_name.nil?
      state_id = nil
    else
      state_id = State.find_by( name: state_name.downcase! ).id
      if (!state_id)
        rise "State not found #{state_name.downcase!}"
      end
    end
    if @strict
      provider = Provider.find_by(nombre_abreviado: pname )
    else
      provider = Provider.where("nombre_abreviado like ?", "#{pname}%" ).first
    end
    if !provider
      raise "Provider not found: #{pname}"
    end
    if ( spec_id.nil? && indicator_id.nil? )
      raise "Relation not set"
    end
    relation = {
      provider_id: provider.id,
      state_id: state_id,
      indicator_value: indicator_value,
      year: @year,
      stage: @stage
    }
    if ( spec_id.nil? )
      relation['indicator_id'] = indicator_id
    else
      relation['specialist_id'] = spec_id
    end
    ProviderRelation.find_or_create_by(relation)
  end

  def state_agregate
    Provider.includes(:provider_relations).where.not("provider_relations.state_id": nil).all.each do |provider|
      specialists = {}
      indicators = {}
      provider.provider_relations.each do |pr|
        if pr.indicator_id.present?
          if indicators.key?(pr.indicator_id)
            indicators[pr.indicator_id][:value] += pr.indicator_value
            indicators[pr.indicator_id][:total] += 1
          else
            indicators[pr.indicator_id] = {total: 1, value: pr.indicator_value}
          end
        elsif pr.specialist_id.present?
          if specialists.key?(pr.specialist_id)
            specialists[pr.specialist_id][:value] += pr.indicator_value
            specialists[pr.specialist_id][:total] += 1
          else
            specialists[pr.specialist_id] = {total: 1, value: pr.indicator_value}
          end
        end
      end
      indicators.keys.each do |i|
        prov_spec_total = ProviderRelation.find_or_initialize_by(state: nil, provider_id: provider.id, indicator_id: i, stage: @stage, year: @year)
        prov_spec_total.indicator_value = (indicators[i][:value]/indicators[i][:total]).round(2)
        prov_spec_total.save
      end
      puts specialists.inspect
      specialists.keys.each do |i|
        prov_spec_total = ProviderRelation.find_or_initialize_by(state: nil, provider_id: provider.id, specialist_id: i, stage: @stage, year: @year)
        prov_spec_total.indicator_value = (specialists[i][:value]/specialists[i][:total]).round(2)
        prov_spec_total.save
      end
    end
  end
  #
  # Create pias
  #
  def pias_data
    puts 'Delete pias'
    Pia.destroy_all

    puts 'Creating pias'
    import_file(@year + '/pias.csv', col_sep: ',') do |row|
      if Pia.where(:pid => row[0]).empty?
        pias = Pia.new(
          pid: row[0],
          titulo: row[1],
          cie_9: row[2],
          informacion: row[3],
          normativa: row[4],
          normativa_url: row[5],
          snomed: row[6],
          orden: $.
        )
        pias.save
      end
    end
  end

  def pias_ancestry
    puts 'Pias hierarchy'
    ActiveRecord::Base.connection.execute("update pia set ancestry = h.ancestry from
      ( select pid, regexp_replace(pid,'(\.[^\.]+)$','') as ancestry from pia )
       as h where  h.pid = pia.pid and pia.pid != h.ancestry;")
  end


  #
  # Create providers
  #
  def providers
    puts 'Creating or updating providers'
    provider_ids = []
    import_file("#{@year + (@stage ? '-'+@stage : '')}/estructura.csv", col_sep: ';') do |row|
      provider = Provider.find_or_create_by( id: row[0] )
      provider_ids.push(row[0])
      provider.update(
        nombre_abreviado: row[1],
        nombre_completo: row[2],
        web: row[3],
        afiliados_fonasa: row[4],
        afiliados: row[6],
        logo: assign_logo(row[0]),
        comunicacion: row[7],
        espacio_adolescente: row[8],
        servicios_atencion_adolescentes: row[9],
        private_insurance: provider.nombre_abreviado.include?('Seguro Privado') ? true : nil
      )
    end
    to_deactivate = Provider.where.not(id: provider_ids)
    puts "\nDELETING #{to_deactivate.map(&:id).inspect}\n\n\n"
    to_deactivate.destroy_all
  end

  def sedes
    puts 'Importing sites'
    importing('sedes', @year + (@stage ? '-'+@stage : '') ) do |provider, parameters|
      state = State.find_by_name(parameters['departamento'].strip.mb_chars.downcase.to_s)
      parameters['state_id'] = state.id
      provider.sites.create(parameters)
    end
  end

  def provider_partial_data
    [ :metas, :solicitud_consultas, :precios, :tiempos_espera].each do |importable|
      puts "Importing #{importable}"
      importing(importable, @year + (@stage ? '-'+@stage : ''))
    end
  end

  #
  # Get structure
  #
  def structure
    Provider.all.each do |provider|
      provider_structure(provider)
    end
  end

  #
  # Assign search name
  #
  def assign_search_name
    Provider.all.each do |provider|
      search_name = "#{provider.nombre_abreviado} - #{provider.nombre_completo}"
      provider.update_attributes(search_name: search_name)
    end
  end

  #
  # Calculate Maximums
  #
  def calculate_maximums
    maximums = ProviderMaximum.first || ProviderMaximum.new
    # Waiting times
    puts 'Calculating Waiting times'
    value = 0
    Provider.all.each do |provider|
      [
        'medicina_general', 'pediatria', 'cirugia_general', 'ginecotocologia', 'cardiologia',
        'medicina_general_presencial', 'pediatria_presencial', 'cirugia_general_presencial', 'ginecotocologia_presencial', 'cardiologia_presencial',
        'medicina_general_virtual', 'pediatria_virtual', 'cirugia_general_virtual', 'ginecotocologia_virtual', 'cardiologia_virtual',
      ].map do |field|
        the_thing = provider.send("tiempo_espera_#{field}".to_sym)
        if  the_thing && the_thing > value
          value = provider.send("tiempo_espera_#{field}".to_sym)
        end
      end
    end

    maximums.waiting_time = value

    # Affiliates
    puts 'Calculating Affiliates'
    maximums.affiliates = Provider.all.map(&:afiliados).compact.reduce(:+)

    # Tickets
    puts 'Calculating Tickets'
    Provider.all.map do |provider|
      [:medicamentos, :tickets, :tickets_urgentes, :estudios].map do |ticket|
        ['fonasa', 'no_fonasa'].map do |tipo|
          average = provider.average(ticket, tipo)
          value = average if (average && average > value)
        end
      end
    end
    maximums.tickets = value

    # Personnel
    puts 'Calculating personnel'
    value = 0
    Provider.all.map do |provider|
      [:medicos_generales_policlinica,
       :medicos_de_familia_policlinica,
       :medicos_pediatras_policlinica,
       :medicos_ginecologos_policlinica,
       :auxiliares_enfermeria_policlinica,
       :licenciadas_enfermeria_policlinica].map do |position|
        quantity = provider.send(position).to_f
        if quantity > value
          value = quantity
        end
      end
    end
    maximums.personnel = value
    maximums.save
  end
end
