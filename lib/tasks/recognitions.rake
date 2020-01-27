require "#{Rails.root}/lib/importer_helper"
namespace :importer do
  desc 'Importar reconocimientos'
  task recognitions: [:environment] do
    # csv: Reconocimiento, Institución, Idprestador, Departamento,
    # Identificación de la práctica, Año, Nombre del archivo, Ícono
    Recognition.destroy_all
    import_file('recognitions.csv', col_sep: ';') do |row|
      Recognition.create(
        recognition: row[0],
        institution: row[1],
        provider_id: row[2].to_i,
        state:       row[3],
        practice:    row[4],
        year:        row[5],
        link:        row[6],
        icon:        row[7] == "MBP" ? :mbp : :mencion
      )
    end
  end
end
