# Estructura de A Tu Servicio 3.0
Toda la Metadata se encuentra en el archivo config/metadata.yml
## Prestadores
Contiene toda la información base de los prestadores
### Datos generales
File: db/data/<año>-<período>/provider.csv
Población y datos base
Importador: Desactiva todos los prestadores no presentes en el archivo (contemplar año)    
### Indicadores
#### RRHH - General
File: db/data/<año>-<período>/rrhh_general.csv   
#### RRHH - Cargos de alta dedicación
File: db/data/<año>-<período>/rrhh_cad.csv   
#### Metas
File: db/data/<año>-<período>/metas.csv
### Recursos Humanos
File: db/data/<año>-<período>/rrhh_especialistas.csv   
### Sedes
Sedes de los prestadores, vinculados a zonas para localización geográfica
File: db/data/<año>-<período>/sedes.csv
## Precios
File: db/data/<año>-<período>/precios.csv
Precios evaluados. Los precios evaulados se socian al prestador por año y período. 
## Tiempos de espera
-- No implementado
File: db/data/<año>-<período>/tiempos_de_espera.csv   
## Zonas
Las zonas establecen una jerarquía interna para representar la especificidad necesaria (País, Departamento, Localidad, Ciudad) a través del campo wkt interpretado en el manejo del frontend con leaflet    
## Especialidades
Las especialidades se vinculan con los recursos humanos asociados a los prestadores a través de los años.    
## Secciones
Secciones de los datos de prestadores, todas las secciones activas se muestran en el detalle de un prestador  
### Tarjetas en home
Cada sección tiene la posibilidad de mostrarse en la home o no. Para secciones nuevas deberá realizarse un desarrollo que elija los datos a mostrar. Para las existenttes podrán activarse o desactivarse desde la interfaz de administración.