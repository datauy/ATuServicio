require 'csv'

module ImporterHelper
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

  def import_file(file, custom_options = nil, &block)
    options = {
      headers: true,
      converters: [:all, :true_indicator, :false_indicator]
    }
    options.merge!(custom_options) if custom_options
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

  CSV::Converters[:no_data] = lambda do |data|
    (data.downcase == 's/d') ? nil : data
  end
end
