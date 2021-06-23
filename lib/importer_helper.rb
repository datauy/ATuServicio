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
      converters: [:all, :true_indicator, :false_indicator, :no_data]
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
    logo_file = Dir["./app/assets/images/logos/#{id}-*.png"]
    logo = /logos\/([0-9]+\-[a-z\-]+\.png)/.match(logo_file[0])[1]
    logo if logo
  rescue
    'no-logo.png'
  end

  # TODO
  def importing(name, year, more_options = nil, &block)
    options = {col_sep: ';'}
    options.merge!(more_options) if more_options
    headers = get_columns(name)
    import_file("#{year}/#{name}.csv", options) do |row|
      provider = Provider.find_by(id: row[0].to_i)
      parameters = get_parameters(headers, row)
      if block && provider
        yield(provider, parameters)
      elsif provider
        provider.update(parameters)
      else
        puts "#{name} - No existe proveedor para #{row[0]}"
      end
    end
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

  def provider_structure(provider)
    structures = {}
    structures[:primaria] = provider.sites.where(nivel: ['Sede Central', 'Sanatorio', 'Sede Principal']).count
    structures[:secundaria] = provider.sites.where(nivel: ['Sede Secundaria', 'Ambulatorio - Sede Secundaria']).count
    # Convención: nil es ambulatorio
    ambulatorios = ['Ambulatorio', 'Centro de Salud',  'Ambulatorio - Policlínica',
      'Ambulatorio - Sede Secundaria', 'Ambulatorio - Serv. Medicina Nuclear',
      'Ambulatorio - Serv. de Fertilidad', 'Ambulatorio(ASSE)', nil]
    structures[:ambulatorio] = provider.sites.where(nivel: ambulatorios).count
    provider.update_attributes(
      estructura_primaria: structures[:primaria],
      estructura_secundaria: structures[:secundaria],
      estructura_ambulatorio: structures[:ambulatorio]
    )
  end
end
