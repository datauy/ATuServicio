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
        web: row[4],
        fonasa_affiliates: row[5],
        afiliados: row[6]
      )
      # Set private insurances
      provider.private_insurance = true if provider.nombre_abreviado.include?('Seguro Privado')
      provider.save
    end
  end

  desc 'Import prices'
  task prices: [:environment] do
    puts 'Importing prices'
    importing('precios')
  end

  desc 'Import goals'
  task goals: [:environment] do
    puts 'Importing goals'
    importing('metas')
  end

  desc 'Import rrhh'
  task rrhh: [:environment] do
    puts 'Importing humans'
    importing('rrhh', {col_sep: ','})
  end

  desc 'Get satisfaction'
  task get_satisfaction: [:environment] do
    puts 'I can\'t get no satisfaction'
    importing('satisfaccion_derechos')
  end

  desc 'Import consultations'
  task consultas: [:environment] do
    puts 'Importing consultas'
    importing('solicitud_consultas', {col_sep: ','})
  end

  desc 'Sites'
  task sites: [:environment] do
    puts 'Importing sites'
    importing('sedes') do |provider, parameters|
      byebug unless parameters['departamento']
      state = State.find_by_name(parameters['departamento'].strip.mb_chars.downcase.to_s)
      byebug unless state
      parameters['state_id'] = state.id
      provider.sites.create(parameters)
    end
  end
end

def importing(name, more_options = nil, &block)
  options = {col_sep: ';'}
  options.merge!(more_options) if more_options
  import_file("2015/#{name}.csv", options) do |row|
    headers = get_columns(name)
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
