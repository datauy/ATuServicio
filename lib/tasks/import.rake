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
    import_csv('sedes') do |provider, parameters|
      provider.sites.create(parameters)
    end
  end

  desc "Import data from CSV. Erases previous information"
  task :import => [:environment, :create_providers, :import_sites] do
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

CSV::Converters[:true_indicator] = lambda do |data|
  (data.downcase == "si") ? true : data
end

CSV::Converters[:false_indicator] = lambda do |data|
  (data.downcase == "no") ? false : data
end

