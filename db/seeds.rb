require 'csv'


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

import('db/data/estructura.csv') {
  puts 'import'
  Provider.create_or_update(
    id: row[0],
    nombre_abreviado: row[1],
    nombre_completo: row[2],
    web: row[3]
  )
}

import('db/data/metas.csv') {
  puts 'import'
  Provider.create_or_update(
    id: row[0],
    afiliados: row[1],
    meta_medico_referencia: row[2],
    meta_ninos_controlados: row[3],
    meta_embarazadas: row[4],
    espacio_adolescente: row[5],
    comunicacion: row[6]
  )
}
