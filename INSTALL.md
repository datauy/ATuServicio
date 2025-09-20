## Instalación

Local:

1. Bundle - `bundle`
2. Levantar base de datos (postgres): `rake db:create db:migrate importer:states importer:all[year]`

## Configuración y CSV's

### /config/metadata.yml
Definición de los metadatos. Mapea archivos CSV a datos. Las llaves son los nombres de los archivos csv's a importar, y ahí se encuentra la estructura a la que vamos a transformar las cosas:

```ruby
2.2.2 :005 > METADATA.keys
 => [:estructura, :metas, :precios, :sedes, :tiempos_espera,
 :satisfaccion_derechos, :rrhh, :solicitud_consultas]
```

Cada elemento tiene 4 grupos:
* `title` - Ejemplo: "Estructura", "Metas Asistenciales"
* `description` - Descripción que mapea a cada columna
* `columns` - Nombre de la columna en el objeto (y la BD)
* `definition` - Los tipos de cada columna (text, boolean, decimal)

Estos datos se cargan en `config/initializers/metadata.rb` en el array `METADATA`.

### estructura.csv
Datos de estructura de los proveedores. Se usa para importar proveedores (ASSE, Española, Casmu, etc.), se mapean al objeto Provider.

### sedes.csv
Datos de sedes (id, dirección, departamento, localildad, nivel, servicios), se mapean al objeto Site.

### metas.csv
Metas asistenciales (porcentaje de afiliados, etc.). Datos que se agregan al objeto Provider.

### precios.csv
Precios de tickets para medicamntos, consultas, demás. Datos que se agregan al objeto Provider.

### tiempos_espera.csv
Tiempos de espera. Datos que se agregan al objeto Provider.

### satisfaccion_derechos.csv
Satisfacción de derechos de usuario (conformidad con disponiblidad, evaluación de tiempos de espera, etc.). Datos que se agregan al objeto Provider.

### rrhh.csv
Recursos Humanos, cargos de médicos generales, de familia, etc. Datos que se agregan al objeto Provider.

### solicitud_consultas.csv
Solicitud de consultas (reserva presencial, telefónica, web). Datos que se agregan al objeto Provider.

## Importando los datos

En el directorio `lib/` del proyecto hay un script `convert.sh` que convierte todos los archivos CSV de su encoding a utf-8 para Ruby. A su vez, hay que fijarse bien el tema de las comas, punto y coma y punto para separadores de columna y decimales.

## Logos

Los logos deben ir en el directorio `app/assets/images/logos` con el siguiente formato de nombre:

```ruby
"#{provider.id}-solo-letras-minusculas.png"
```

Archivos PNG nombre sólo letras (sin acentos ni símbolos) y separado del ID de proveedor (por practicidad).

## Dependencias

Los detalles de las dependecias se encuentran en el archivo [COPYRIGHT.md](COPYRIGHT.md).


# ATuServicio 2.0
ATS install

## Ruby version manager (asdf), follow your own 
`asdf plugin update ruby`
`asdf install ruby 3.4.6`
`asdf reshim ruby`
`ruby -v`
	3.4.6
`gem install rails`
`rails new . --database=postgresql`

Add Gems:
gem "image_processing", "~> 1.2"

gem 'devise'
gem 'activeadmin', "~> 4.0.0.beta15"
gem "mini_magick"
gem 'activeadmin-searchable_select'
gem 'active_admin_datetimepicker'
gem 'pagy'
#gem "tailwindcss-rails", "~> 4.2"
gem "cssbundling-rails", "~> 1.4"
gem "sitemap_generator"

`bundle install`

-> Crear base de datos

`rails active_storage:install`

`rails g active_admin:install`

Depending on your application's configuration some manual setup may be required:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

     * Required for all applications. *

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"
     
     * Not required for API-only Applications *

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

     * Not required for API-only Applications *

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views
       
     * Not required *

`rails db:migrate`
`vim package.json`
{
  "dependencies": {
    "@activeadmin/activeadmin": "4.0.0-beta15",
    "tailwindcss": "^3.4.15",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.49"
  },
  "scripts": {
    "build:css": "tailwindcss -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify -c ./app/javascript/tailwind-active_admin.config.js"
  }
}
`yarn install`
`vim ./node_modules/@activeadmin/activeadmin/plugin.js`
replaceAll -> replace
