# See:
require "#{Rails.root}/lib/importer_helper"

include ImporterHelper

namespace :importer do
  @year = '2016'

  desc 'Importing everything'
  task :all, [:year] => [:environment] do |t, args|
    puts 'Import all data'
    @year = args[:year] || @year

    Rake::Task['importer:all'].enhance do
      Rake::Task['importer:states'].invoke
    end

    providers
    provider_data
    calculate_maximums
    assign_search_name
    structure
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
        comunicacion: row[7]
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
      unless state.nil?
        parameters['state_id'] = state.id
        provider.sites.create(parameters)
      end
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
        if average && average > value
          value = average
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
