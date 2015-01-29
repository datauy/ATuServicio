require 'csv'

namespace :db do
  desc "Create providers"
  task :create_providers => [:environment] do
    import_file('estructura.csv') do |row|
      Provider.create(id: row[0])
    end
  end

  desc "Add provider data info"
  task :import => [:environment, :create_providers] do
    METADATA.keys.each do |group|
      import_file("#{group}.csv") do |row|
        headers = get_columns(group)
        provider = Provider.find_by(id: row[0].to_i)

        if provider
          provider.update(get_parameters(headers, row))
        else
          puts "#{group} - No existe proveedor para #{row[0]}"
        end
      end
    end
  end

  def get_columns(filename)
    METADATA[filename]['columns']
  end

  def import_file(file, &block)
    options = { headers: true,
                converters: [:all, :empty_data, :true_indicator, :false_indicator]
              }
    CSV.foreach(File.join(Rails.root, "db/data/", file), options) do |row|
      yield row
    end
  end

  def get_parameters(headers, row)
    values = row.fields[1..-1]
    headers.zip(values).map{|p| Hash[*p]}.inject({}){|h1, h2| h1.merge(h2)}
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

