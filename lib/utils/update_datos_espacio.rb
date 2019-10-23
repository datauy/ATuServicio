# Usado en el caso que faltaban datos espacio adolescente 2019 para copiar los
# datos de 2018. Lo agrego al repo en caso que se pueda reutilizar el código
# para herramientas similares de proceso de los datos.

require 'csv'

datos_2018 = './../../db/data/2018/estructura.csv'
datos_2019 = './../../db/data/2019/estructura.csv'
csv_2018 = CSV.read(datos_2018, headers: true, col_sep: ';')
csv_2019 = CSV.read(datos_2019, headers: true, col_sep: ';')

# Ésto genera un segundo archivo de estructura que puede reemplazar al anterior
# después de verificado que estén todos los valores bien.
CSV.open('./../../db/data/2019/estructura_2.csv', 'wb', col_sep: ';') do |csv|
  csv_2018.each do |row|
    item_2019 = csv_2019.select do |a|
      a['id_mutualista'] == row['Id_Institución']
    end.first

    item_2019['existencia de servicio de salud para adolescente s/n'] = row['existencia de servicio de salud para adolescente s/n']

    csv << item_2019
  end
end

