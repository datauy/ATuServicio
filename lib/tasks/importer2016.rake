# See:
require "#{Rails.root}/lib/importer_helper"
include ImporterHelper

namespace :importer do
  desc 'Create providers'
  task providers: [:environment] do
    puts 'Delete providers'
    Provider.destroy_all

    puts 'Creating providers'

    import_file('2015/estructura.csv') do |row|
      provider = Provider.new(
        id: row[0],
        nombre_abreviado: row[1],
        nombre_completo: row[2],
        web: row[3],
        afiliados_fonasa: row[4],
        afiliados: row[6]
      )
      # Set private insurances
      provider.private_insurance = true if provider.nombre_abreviado.include?('Seguro Privado')
      provider.save
    end
  end

  desc 'Import provider data'
  task provider_data: [:environment] do
    [:precios, :metas, :satisfaccion_derechos, :tiempos_espera].each do |importable|
      puts "Importing #{importable}"
      importing(importable)
    end

    [:rrhh, :solicitud_consultas].each do |importable|
      puts "Importing #{importable}"
      importing('rrhh', col_sep: ',')
    end

    puts 'Importing sites'
    importing('sedes') do |provider, parameters|
      state = State.find_by_name(parameters['departamento'].strip.mb_chars.downcase.to_s)
      parameters['state_id'] = state.id
      provider.sites.create(parameters)
    end
  end

  desc 'Import States'
  task states: [:environment] do
    puts 'Import states'
    states = YAML.load_file('config/states.yml')
    states.each do |state|
      State.create(
        name: state
      )
    end
  end

  desc "Assign search name"
  task :assign_search_name => [:environment] do
    Provider.all.each do |provider|
      search_name = "#{provider.nombre_abreviado} - #{provider.nombre_completo}"
      provider.update_attributes(search_name: search_name)
    end
  end

  desc 'Calculate Maximums'
  task :calculate_maximums => [:environment] do
    maximums = ProviderMaximum.first || ProviderMaximum.new
    # Waiting times
    puts 'Calculating Waiting times'
    value = 0
    Provider.all.each do |provider|
      ['medicina_general', 'pediatria', 'cirugia_general',
       'ginecotocologia', 'medico_referencia'].map do |field|
        if provider.send("datos_suficientes_tiempo_espera_#{field}".to_sym)
          if provider.send("tiempo_espera_#{field}".to_sym) > value
            value = provider.send("tiempo_espera_#{field}".to_sym)
          end
        end
      end
    end

    maximums.waiting_time = value

    # Affiliates
    puts 'Calculating Affiliates'
    maximums.affiliates = Provider.all.map(&:afiliados).compact.reduce(:+)

    # Tickets
    puts 'Calculating Tickets'
    value = Provider.all.map do |provider|
      [:medicamentos, :tickets, :tickets_urgentes, :estudios].map do |ticket|
        average = provider.average(ticket)
        if average
          average
        end
      end.compact.reduce(:+)
    end.compact.max
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

  desc 'Importing everything'
  task all: [:environment] do
    puts 'Import all data'
  end

  Rake::Task['importer:all'].enhance do
    Rake::Task['importer:states'].invoke
    Rake::Task['importer:providers'].invoke
    Rake::Task['importer:provider_data'].invoke
    Rake::Task['importer:calculate_maximums'].invoke
    Rake::Task['importer:assign_search_name'].invoke
  end
end
