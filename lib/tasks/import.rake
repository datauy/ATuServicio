require 'csv'

namespace :db do
  desc "Create providers"
  task :create_providers => [:environment] do
    puts "Deleting all providers"
    Provider.destroy_all

    puts "Creating providers"
    import_file('estructura.csv') do |row|
      Provider.create(id: row[0])
    end
  end

  desc "Import provider sites"
  task :import_sites => [:environment, :create_providers] do
    puts "Import provider sites"
    ProviderStateInfo.delete_all
    Site.delete_all
    import_csv('sedes') do |provider, parameters|
      state = State.find_or_create_by(name: parameters['departamento'])
      ProviderStateInfo.find_or_create_by(provider: provider, state: state)
      provider.sites.create(parameters.merge(state: state))
      # provider.states << state
      # state.providers << provider unless state.providers.exists?(provider)
    end
  end

  task :load_providers_states => [:environment, :import_sites] do
    puts "import Provider State info"
    ProviderStateInfo.all.each do |info|
      level_count = Site.where(state_id: info.state_id,
                         provider_id: info.provider_id).group(:nivel).count
      urgencia = Site.where(state_id: info.state_id,
                            provider_id: info.provider_id).count(:servicio_de_urgencia) > 0
      info.update(primaria: level_count['Sede Central'] || 0,
                  secundaria: level_count['Sede Secundaria'] || 0,
                  ambulatorio: level_count['Ambulatorio'] || 0,
                  urgencia: urgencia)
    end

  end

  desc "Import data from CSV. Erases previous information"
  task :import => [:environment, :create_providers, :import_sites, :load_providers_states] do
    puts "Import all data into providers"
    import_csv(*get_provider_groups) do |provider, parameters|
      provider.update(parameters)
    end
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
  options = { headers: true,
              converters: [:all, :empty_data, :true_indicator, :false_indicator]
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


# CSV converters, used to transform cells when parsing the CSV
# 0 values are not valid in this case
# Data has not been provided if 0
CSV::Converters[:empty_data] = lambda do |data|
(data == "0") ? nil : data
end

CSV::Converters[:true_indicator] = lambda do |data|
(data.downcase == "si") ? true : data
end

CSV::Converters[:false_indicator] = lambda do |data|
(data.downcase == "no") ? false : data
end

