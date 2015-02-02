# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150202142023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "providers", force: :cascade do |t|
    t.string  "nombre_abreviado"
    t.string  "nombre_completo"
    t.string  "web"
    t.integer "afiliados"
    t.decimal "meta_medico_referencia",                            precision: 9, scale: 2
    t.decimal "meta_ninos_controlados",                            precision: 9, scale: 2
    t.decimal "meta_embarazadas",                                  precision: 9, scale: 2
    t.boolean "espacio_adolescente"
    t.text    "comunicacion"
    t.decimal "ticket_de_medicamentos_general_fonasa",             precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_general_no_fonasa",          precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_topeados_fonasa",            precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_topeados_no_fonasa",         precision: 9, scale: 2
    t.decimal "consulta_medicina_general_fonasa",                  precision: 9, scale: 2
    t.decimal "consulta_medicina_general_no_fonasa",               precision: 9, scale: 2
    t.decimal "consulta_pediatria_fonasa",                         precision: 9, scale: 2
    t.decimal "consulta_pediatria_no_fonasa",                      precision: 9, scale: 2
    t.decimal "consulta_control_de_embarazo_fonasa",               precision: 9, scale: 2
    t.decimal "consulta_control_de_embarazo_no_fonasa",            precision: 9, scale: 2
    t.decimal "consulta_ginecologia_fonasa",                       precision: 9, scale: 2
    t.decimal "consulta_ginecologia_no_fonasa",                    precision: 9, scale: 2
    t.decimal "consulta_otras_especialidades_fonasa",              precision: 9, scale: 2
    t.decimal "consulta_otras_especialidades_no_fonasa",           precision: 9, scale: 2
    t.decimal "consulta_urgencia_centralizada_fonasa",             precision: 9, scale: 2
    t.decimal "consulta_urgencia_centralizada_no_fonasa",          precision: 9, scale: 2
    t.decimal "consulta_no_urgencia_domicilio_fonasa",             precision: 9, scale: 2
    t.decimal "consulta_no_urgencia_domicilio_no_fonasa",          precision: 9, scale: 2
    t.decimal "consulta_urgencia_domicilio_fonasa",                precision: 9, scale: 2
    t.decimal "consulta_urgencia_domicilio_no_fonasa",             precision: 9, scale: 2
    t.decimal "consulta_odontologica_fonasa",                      precision: 9, scale: 2
    t.decimal "consulta_odontologica_no_fonasa",                   precision: 9, scale: 2
    t.decimal "consulta_medico_de_referencia_fonasa",              precision: 9, scale: 2
    t.decimal "consulta_medico_de_referencia_no_fonasa",           precision: 9, scale: 2
    t.decimal "endoscopia_digestiva_endoscopia_fonasa",            precision: 9, scale: 2
    t.decimal "endoscopia_digestiva_endoscopia_no_fonasa",         precision: 9, scale: 2
    t.decimal "ecografia_simple_fonasa",                           precision: 9, scale: 2
    t.decimal "ecografia_simple_no_fonasa",                        precision: 9, scale: 2
    t.decimal "ecodoppler_fonasa",                                 precision: 9, scale: 2
    t.decimal "ecodoppler_no_fonasa",                              precision: 9, scale: 2
    t.decimal "rx_simple_fonasa",                                  precision: 9, scale: 2
    t.decimal "rx_simple_no_fonasa",                               precision: 9, scale: 2
    t.decimal "rx_torax_fonasa",                                   precision: 9, scale: 2
    t.decimal "rx_torax_no_fonasa",                                precision: 9, scale: 2
    t.decimal "rx_colorectal_fonasa",                              precision: 9, scale: 2
    t.decimal "rx_colorectal_no_fonasa",                           precision: 9, scale: 2
    t.decimal "resonancia_fonasa",                                 precision: 9, scale: 2
    t.decimal "resonancia_no_fonasa",                              precision: 9, scale: 2
    t.decimal "tomografia_fonasa",                                 precision: 9, scale: 2
    t.decimal "tomografia_no_fonasa",                              precision: 9, scale: 2
    t.decimal "laboratorio_rutina_basica_fonasa",                  precision: 9, scale: 2
    t.decimal "laboratorio_rutina_basica_no_fonasa",               precision: 9, scale: 2
    t.decimal "tiempo_espera_medicina_general",                    precision: 9, scale: 2
    t.decimal "tiempo_espera_pediatria",                           precision: 9, scale: 2
    t.decimal "tiempo_espera_cirugia_general",                     precision: 9, scale: 2
    t.decimal "tiempo_espera_ginecotocologia",                     precision: 9, scale: 2
    t.decimal "tiempo_espera_medico_referencia",                   precision: 9, scale: 2
    t.boolean "datos_suficientes_tiempo_espera_medicina_general"
    t.boolean "datos_suficientes_tiempo_espera_pediatria"
    t.boolean "datos_suficientes_tiempo_espera_cirugia_general"
    t.boolean "datos_suficientes_tiempo_espera_ginecotocologia"
    t.boolean "datos_suficientes_tiempo_espera_medico_referencia"
    t.decimal "conformidad_disponibilidad_agenda_2014",            precision: 9, scale: 2
    t.decimal "conformidad_disponibilidad_agenda_2010",            precision: 9, scale: 2
    t.decimal "evaluacion_tiempo_espera_sala_2014",                precision: 9, scale: 2
    t.decimal "evaluacion_tiempo_espera_sala_2010",                precision: 9, scale: 2
    t.decimal "facilidad_para_realizar_tramites_gestiones_2014",   precision: 9, scale: 2
    t.decimal "facilidad_para_realizar_tramites_gestiones_2010",   precision: 9, scale: 2
    t.decimal "disponibilidad_medicamentos_farmacia_2014",         precision: 9, scale: 2
    t.decimal "disponibilidad_medicamentos_farmacia_2010",         precision: 9, scale: 2
    t.decimal "informacion_sobre_derechos_2014",                   precision: 9, scale: 2
    t.decimal "informacion_sobre_derechos_2010",                   precision: 9, scale: 2
    t.decimal "queja_sugerencia_sabe_donde_dirigirse_2014",        precision: 9, scale: 2
    t.decimal "queja_sugerencia_sabe_donde_dirigirse_2010",        precision: 9, scale: 2
    t.decimal "satisfaccion_primer_nivel_atencion_2014",           precision: 9, scale: 2
    t.decimal "satisfaccion_primer_nivel_atencion_2010",           precision: 9, scale: 2
    t.decimal "satisfaccion_internacion_hospitalaria_2012",        precision: 9, scale: 2
    t.decimal "medicos_generales_policlinica",                     precision: 9, scale: 2
    t.decimal "medicos_de_familia_policlinica",                    precision: 9, scale: 2
    t.decimal "medicos_pediatras_policlinica",                     precision: 9, scale: 2
    t.decimal "medicos_ginecologos_policlinica",                   precision: 9, scale: 2
    t.decimal "auxiliares_enfermeria_policlinica",                 precision: 9, scale: 2
    t.decimal "licenciadas_enfermeria_policlinica",                precision: 9, scale: 2
    t.decimal "cantidad_cad",                                      precision: 9, scale: 2
    t.decimal "medicina_general_cantidad_cad",                     precision: 9, scale: 2
    t.decimal "medicina_familiar_cantidad_cad",                    precision: 9, scale: 2
    t.decimal "pediatria_cantidad_cad",                            precision: 9, scale: 2
    t.decimal "ginecotologia_cantidad_cad",                        precision: 9, scale: 2
    t.decimal "medicina_interna_cantidad_cad",                     precision: 9, scale: 2
    t.decimal "medicina_intensiva_adultos_cantidad_cad",           precision: 9, scale: 2
    t.decimal "medicina_intensiva_pediatrica_cantidad_cad",        precision: 9, scale: 2
    t.decimal "neonatologia_cantidad_cad",                         precision: 9, scale: 2
  end

  add_index "providers", ["state_id"], name: "index_providers_on_state_id", using: :btree

  create_table "providers_states", id: false, force: :cascade do |t|
    t.integer "provider_id", null: false
    t.integer "state_id",    null: false
  end

  add_index "providers_states", ["provider_id", "state_id"], name: "index_providers_states_on_provider_id_and_state_id", using: :btree
  add_index "providers_states", ["state_id", "provider_id"], name: "index_providers_states_on_state_id_and_provider_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.integer  "provider_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "direccion"
    t.string   "departamento"
    t.string   "localidad"
    t.string   "nivel"
    t.boolean  "servicio_de_urgencia"
    t.boolean  "alergista"
    t.boolean  "anestesiologia"
    t.boolean  "cardiologia"
    t.boolean  "cirugia"
    t.boolean  "cirugia_reparadora"
    t.boolean  "cirugia_vascular"
    t.boolean  "deportologia"
    t.boolean  "dermatologia"
    t.boolean  "endocrinolgia"
    t.boolean  "fisiatria"
    t.boolean  "gastroenterologia"
    t.boolean  "geriatria"
    t.boolean  "ginecologia"
    t.boolean  "hematologia"
    t.boolean  "infectologia"
    t.boolean  "medicina_general"
    t.boolean  "medicina_interna"
    t.boolean  "medicina_intensiva"
    t.boolean  "nefrologia"
    t.boolean  "neonatologia"
    t.boolean  "neumologia"
    t.boolean  "neurocirugia"
    t.boolean  "neurologia"
    t.boolean  "neuropediatria"
    t.boolean  "odontologia"
    t.boolean  "oncologia"
    t.boolean  "otorrinolaringologia"
    t.boolean  "pediatria"
    t.boolean  "psiquiatria"
    t.boolean  "psiquiatria_infantil"
    t.boolean  "reumatologia"
    t.boolean  "traumatologia"
    t.boolean  "urologia"
  end

  add_index "sites", ["provider_id"], name: "index_sites_on_provider_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "providers", "states"
  add_foreign_key "sites", "providers"
end
