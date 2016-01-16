require 'csv'

namespace :db do
  desc "Create providers"
  task :create_providers => [:environment] do
    puts "Deleting all providers"
    Provider.destroy_all

    puts "Creating providers"
    Provider.transaction do
      import_file('estructura.csv') do |row|
        id = row[0]
        Provider.create(
          id: id,
          logo: assign_logo(id)
        )
      end
    end
  end

  desc "Import provider sites"
  task :import_sites => [:environment, :create_providers] do
    puts "Import provider sites"
    import_csv('sedes') do |provider, parameters|
      provider.sites.create(parameters)
    end
  end

  desc "Import data from CSV. Erases previous information"
  task :import => [:environment, :create_providers, :import_sites] do
    puts "Import all data into providers"
    import_csv(*get_provider_groups) do |provider, parameters|
      provider.update(parameters)

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
    value = Provider.all.map do |provider|
      ['medicina_general', 'pediatria', 'cirugia_general',
       'ginecotocologia', 'medico_referencia'].map do |field|
        if provider.send("datos_suficientes_tiempo_espera_#{field}".to_sym)
          provider.send("tiempo_espera_#{field}".to_sym)
        end
      end.compact.reduce(:+)
    end.compact.max
    maximums.waiting_time = value

    # Affiliates
    puts "Calculating Affiliates"
    maximums.affiliates = Provider.maximum("afiliados")

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
    value = Provider.all.map do |provider|
      [:medicos_generales_policlinica,
       :medicos_de_familia_policlinica,
       :medicos_pediatras_policlinica,
       :medicos_ginecologos_policlinica,
       :auxiliares_enfermeria_policlinica,
       :licenciadas_enfermeria_policlinica].map do |position|
        value = provider.send(position).to_f
        if value.is_a? Numeric
          value
        end
      end.compact.reduce(:+)
    end.compact.max
    maximums.personnel = value

    maximums.save
  end

  Rake::Task['db:import'].enhance do
    Rake::Task['db:calculate_maximums'].invoke
    Rake::Task['db:assign_search_name'].invoke
  end

end

def get_provider_groups
  METADATA.except(:sedes).keys
end

def get_columns(filename)
  METADATA[filename.to_sym][:columns]
end

def get_parameters(headers, row)
  values = row.fields[1..-1]
  headers.zip(values).map{|p| Hash[*p]}.inject({}){|h1, h2| h1.merge(h2)}
end

def import_file(file, &block)
  options = {
    headers: true,
    converters: [:all, :true_indicator, :false_indicator]
  }
  CSV.foreach(File.join(Rails.root, "db/data/", file), options) do |row|
    yield row
  end
end

def import_csv(*groups, &block)
  groups.each do |group|
    import_file("#{group}.csv") do |row|
      headers = get_columns(group)
      provider = Provider.find_by(id: row[0].to_i)
      parameters = get_parameters(headers, row)

      if provider
        yield(provider, parameters)
      else
        puts "#{group} - No existe proveedor para #{row[0]}"
      end
    end
  end
end

# Logos should live in app/assets/images/logos
# The image name should have the provider's ID first, followed by the
# provider's name and in png format.
def assign_logo(id)
  # Hack ASSE:
  if id.between?(90_000, 90_020)
    logo = '90000-asse.png'
  else
    logo_file = Dir["./app/assets/images/logos/#{id}-*.png"]
    logo = /logos\/([0-9]+\-[a-z\-]+\.png)/.match(logo_file[0])[1]
  end
  logo if logo
end

CSV::Converters[:true_indicator] = lambda do |data|
  (data.downcase == "si") ? true : data
end

CSV::Converters[:false_indicator] = lambda do |data|
  (data.downcase == "no") ? false : data
end

