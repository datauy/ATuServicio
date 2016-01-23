require "#{Rails.root}/lib/importer_helper"
include ImporterHelper

namespace :importer do
  desc 'Create providers'
  task create_providers: [:environment] do
    puts "Delete providers"
    Provider.destroy_all

    puts "Creating providers"
    import_file('2015/estructura.csv') do |row|
      Provider.create(
        id: row[0],
        nombre_abreviado: row[1],
        nombre_completo: row[2],
        web: row[4],
        fonasa_affiliates: row[5],
        afiliados: row[6]
      )
    end
  end
end

