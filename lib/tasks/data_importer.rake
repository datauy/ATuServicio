# See:
require "#{Rails.root}/lib/importer_helper"

include ImporterHelper

namespace :importer do
  @year = '2018'

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
    provider_data
    calculate_maximums
    assign_search_name
    structure
    Rake::Task['importer:fnr'].invoke
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
  desc 'Import FNR'
  task :fnr, [:year] => [:environment] do
    puts 'Importing FNR data'
    @imported = 0
    @duplicated = 0
=begin
    import_tag('imaes.csv', Imae)
    import_tag('areas_acto.csv', InterventionArea)
    import_tag('tipos_acto.csv', InterventionType)
    import_file("fnr/espera-test.csv", col_sep: ',', headers: true) do |row|
      interventionRecord = {
        imae_id: row[0],
        intervention_area_id: row[2],
        intervention_type_id: row[4],
        realizado: Date.parse(row[6]),
        autorizado: Date.parse(row[9]),
      }
      if Intervention.where(interventionRecord).empty?
        Intervention.create(interventionRecord)
        @imported += 1
      else
        # Ver qué hacemos con duplicados, por ahora nada
        @duplicated += 1
      end
    end
=end
    #Since we don't have the id yet we will match the transformed waitting time IMAE name
    @imaesNamed_obj = Imae.all.map {|i| {id: i.id, name: i.nombre.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase} }
    #Load tags and states for inner search
    @areas_obj = InterventionArea.all
    @types_obj = InterventionType.all
    @states_obj = State.all
    @providers_obj = Provider.select("id, nombre_abreviado").all
    import_file("#{@year}/microdatos_autorizaciones_2018.csv", col_sep: ';', headers: true) do |row|
      Rails.logger.info "\n\n ARRANCA IMPORT Microdatos \n #{row.inspect}\n"

      #if @imae = Imae.where(nombre: row[15])
      #Duplicate persistent objects for select
      @imaesNamed = @imaesNamed_obj.dup
      @areas = @areas_obj.dup
      @types = @types_obj.dup
      @states = @states_obj.dup
      @providers = @providers_obj.dup
      if !(@imae = @imaesNamed.select { |timae| timae[:name] == row[15] }.first )
        @imae = Imae.create( nombre: row[15] )
        @imae_id = @imae.id
        @imaesNamed_obj << {id: @imae.id, name: @imae.nombre.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase}
      else
        @imae_id = @imae[:id]
      end
      #Area must be matched since distinction like ACTOS CARDIOLOGÍA from ACTOS MÉDICOS CARDIOLOGÍA must be made for both datasets to match
      #row[1] = "DISPOSITIVOS"
      begin
        row[1]["ACTOS"] = "ACTOS MÉDICOS"
      rescue IndexError
      end
      if !(@area = @areas.select { |area| area[:nombre] == row[1] }.first )
        @area = InterventionArea.create( nombre: row[1] )
        @areas_obj << @area
      end
      #Intervention Type is asociated with area
      if !(@type = @types.select { |tipo| tipo[:nombre] == row[3] && tipo[:intervention_area_id] == @area.id }.first )
        @type = InterventionType.create( {nombre: row[3], intervention_area_id: @area.id} )
        @types_obj << @types
      end
      if !( @state = @states.select { |depto| depto[:name] == row[10].to_s.downcase }.first )
        Rails.logger.info "No se encontró el depto: #{row[10]}"
        next
      end
      if !( @provider = @providers.select { |prov| prov[:nombre_abreviado] == row[11].upcase}.first )
        Rails.logger.info "No se encontró el PROVEEDOR: #{row[11]}"
        next
      end
      Rails.logger.info "\n\n ARRANCA4 \n"
      @interventionRecord = {
        imae_id: @imae_id,
        intervention_type_id: @type.id,
        solicitado: Date.parse(row[4]),
        autorizado: Date.parse(row[5]),
        intervention_kind: row[0],
        estado: row[6],
        edad: row[8],
        sexo: row[9],
        state_id: @state.id,
        provider_id: @provider.id
      }
      if Intervention.where(@interventionRecord).empty?
        Intervention.create(@interventionRecord)
        @imported += 1
      else
        # Ver qué hacemos con duplicados, por ahora nada
        @duplicated += 1
      end
      if @imported == 100
        puts "Se importaron #{@imported} No se agregaron #{@duplicated} por estar duplicados"
        exit
      end
    end
  end

  def import_tag(data_file, tagType)
    @imported = 0
    @duplicated = 0
    #With importer gem
    #imaes = []
    #Hacer importador genérico por nombre de columna?
    import_file("tags/"+data_file.to_s, col_sep: ',', headers: true) do |row|
      tagType.create(
        id: row[0],
        nombre: row[1],
      )
      @imported += 1
      # Ver qué hacemos con duplicados, por ahora nada
    rescue ActiveRecord::RecordNotUnique
      @duplicated += 1
    end
    #Imae.import imaes
    puts "Se importaron "+@imported.to_s+". No se agregaron "+@duplicated.to_s+" por estar duplicados"
  end
  #
  # Create pias
  #
  def pias_data
    puts 'Delete pias'
    Pia.destroy_all

    puts 'Creating pias'
    import_file(@year + "/pias.csv", col_sep: ',') do |row|
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
    puts 'Delete providers'
    Provider.destroy_all

    puts 'Creating providers'

    import_file(@year + "/estructura.csv", col_sep: ';') do |row|
      provider = Provider.new(
        id: row[0],
        nombre_abreviado: row[1],
        nombre_completo: row[2],
        web: row[3],
        afiliados_fonasa: row[4],
        afiliados: row[6],
        logo: assign_logo(row[0]),
        comunicacion: row[7],
        espacio_adolescente: row[8],
        servicios_atencion_adolescentes: row[9]
      )
      # Set private insurances
      provider.private_insurance = true if provider.nombre_abreviado.include?('Seguro Privado')
      provider.save
    end
  end

  #
  # Import provider data
  #
  def provider_data
    [:precios, :metas, :satisfaccion_derechos, :tiempos_espera].each do |importable|
      puts "Importing #{importable}"
      importing(importable, @year)
    end

    [:rrhh, :solicitud_consultas].each do |importable|
      puts "Importing #{importable}"
      importing(importable, @year)
    end

    puts 'Importing sites'
    importing('sedes', @year) do |provider, parameters|
      state = State.find_by_name(parameters['departamento'].strip.mb_chars.downcase.to_s)
      parameters['state_id'] = state.id
      provider.sites.create(parameters)
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
      ['medicina_general', 'pediatria', 'cirugia_general',
       'ginecotocologia', 'cardiologia'].map do |field|
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
        average = provider.average(ticket)
        value = average if (average && average > value)
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
