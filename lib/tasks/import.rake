require "#{Rails.root}/lib/importer_helper"
include ImporterHelper

namespace :db do
  desc "Create providers"
  task :create_providers => [:environment] do
    puts "Deleting all providers"
    Provider.destroy_all

    puts "Creating providers"
    import_file('2015/estructura.csv') do |row|
      id = row[0]
      Provider.create(
        id: id,
        logo: assign_logo(id)
      )
    end
  end

  desc "Import provider sites"
  task :import_sites => [:environment, :create_providers] do
    puts "Import provider sites"
    import_csv('sedes') do |provider, parameters|
      state = State.find_by_name(parameters['departamento'].downcase)
      parameters['state_id'] = state.id
      provider.sites.create(parameters)
    end
  end

  desc "Import data from CSV. Erases previous information"
  task :import => [:environment, :create_providers, :import_sites] do
    puts "Import states"
    states = YAML.load_file('config/states.yml')
    states.each do |state|
      State.create(
        name: state
      )
    end

    puts "Import all data into providers"
    import_csv(*get_provider_groups) do |provider, parameters|
      provider.update(parameters)

      # Set private insurances
      provider.update_attributes(private_insurance: true) if provider.nombre_abreviado.include?("Seguro Privado")

      # TODO - Check this
      states = provider.states
      states.each do |state|
        provider.update_attributes(
          estructura_primaria: provider.coverage_by_state(state, 'Sede Central'),
          estructura_secundaria: provider.coverage_by_state(state, 'Sede Secundaria'),
          estructura_ambulatorio: provider.coverage_by_state(state, 'Ambulatorio'),
          estructura_urgencia: provider.coverage_by_state(state, 'Urgencia')
        )
      end
    end
  end

  desc "Assign search name"
  task :assign_search_name => [:environment] do
    Provider.all.each do |provider|
      search_name = "#{provider.nombre_abreviado} - #{provider.nombre_completo}"
      provider.update_attributes(search_name: search_name)
    end
  end

  desc "Calculate Maximums"
  task :calculate_maximums => [:environment] do
    maximums = ProviderMaximum.first || ProviderMaximum.new
    # Waiting times
    puts "Calculating Waiting times"
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
    puts "Calculating Affiliates"
    maximums.affiliates = Provider.all.map(&:afiliados).reduce(:+)

    # Tickets
    puts "Calculating Tickets"
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
    puts "Calculating personnel"
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

  Rake::Task['db:import'].enhance do
    Rake::Task['db:calculate_maximums'].invoke
    Rake::Task['db:assign_search_name'].invoke
  end
end
