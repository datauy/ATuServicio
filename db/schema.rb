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

ActiveRecord::Schema.define(version: 20210615021431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imaes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nombre",     null: false
  end

  create_table "intervention_areas", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intervention_types", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "intervention_area_id"
  end

  add_index "intervention_types", ["intervention_area_id"], name: "index_intervention_types_on_intervention_area_id", using: :btree

  create_table "interventions", force: :cascade do |t|
    t.integer  "intervention_type_id"
    t.string   "estado"
    t.integer  "imae_id"
    t.date     "solicitado"
    t.date     "autorizado"
    t.date     "realizado"
    t.integer  "edad"
    t.string   "sexo"
    t.integer  "state_id"
    t.integer  "provider_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "intervention_kind"
    t.integer  "provider_fnr_id"
  end

  add_index "interventions", ["imae_id"], name: "index_interventions_on_imae_id", using: :btree
  add_index "interventions", ["intervention_type_id"], name: "index_interventions_on_intervention_type_id", using: :btree
  add_index "interventions", ["provider_fnr_id"], name: "index_interventions_on_provider_fnr_id", using: :btree
  add_index "interventions", ["provider_id"], name: "index_interventions_on_provider_id", using: :btree
  add_index "interventions", ["state_id"], name: "index_interventions_on_state_id", using: :btree

  create_table "pia", primary_key: "pid", force: :cascade do |t|
    t.string  "titulo"
    t.string  "cie_9"
    t.string  "informacion"
    t.string  "normativa"
    t.string  "normativa_url"
    t.string  "snomed"
    t.string  "ancestry"
    t.integer "orden"
  end

  add_index "pia", ["ancestry"], name: "index_pia_on_ancestry", using: :btree

  create_table "provider_fnrs", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "state_id"
  end

  add_index "provider_fnrs", ["state_id"], name: "index_provider_fnrs_on_state_id", using: :btree

  create_table "provider_maximums", force: :cascade do |t|
    t.decimal  "tickets"
    t.decimal  "waiting_time"
    t.integer  "affiliates"
    t.decimal  "personnel"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string  "nombre_abreviado"
    t.string  "nombre_completo"
    t.string  "web"
    t.integer "afiliados_fonasa"
    t.integer "afiliados"
    t.text    "comunicacion"
    t.decimal "captacion_rn",                                    precision: 9, scale: 2
    t.decimal "control_desarrollo",                              precision: 9, scale: 2
    t.decimal "control_embarazo_hiv_vdrl",                       precision: 9, scale: 2
    t.decimal "control_pauta_25_a_64_hipertensos",               precision: 9, scale: 2
    t.decimal "capacitacion_infarto_st_elevado",                 precision: 9, scale: 2
    t.decimal "indice_cesareas"
    t.decimal "ticket_de_medicamentos_general_fonasa",           precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_general_no_fonasa",        precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_topeados_fonasa",          precision: 9, scale: 2
    t.decimal "ticket_de_medicamentos_topeados_no_fonasa",       precision: 9, scale: 2
    t.decimal "consulta_medicina_general_fonasa",                precision: 9, scale: 2
    t.decimal "consulta_medicina_general_no_fonasa",             precision: 9, scale: 2
    t.decimal "consulta_pediatria_fonasa",                       precision: 9, scale: 2
    t.decimal "consulta_pediatria_no_fonasa",                    precision: 9, scale: 2
    t.decimal "consulta_control_de_embarazo_fonasa",             precision: 9, scale: 2
    t.decimal "consulta_control_de_embarazo_no_fonasa",          precision: 9, scale: 2
    t.decimal "consulta_ginecologia_fonasa",                     precision: 9, scale: 2
    t.decimal "consulta_ginecologia_no_fonasa",                  precision: 9, scale: 2
    t.decimal "consulta_otras_especialidades_fonasa",            precision: 9, scale: 2
    t.decimal "consulta_otras_especialidades_no_fonasa",         precision: 9, scale: 2
    t.decimal "consulta_urgencia_centralizada_fonasa",           precision: 9, scale: 2
    t.decimal "consulta_urgencia_centralizada_no_fonasa",        precision: 9, scale: 2
    t.decimal "consulta_no_urgencia_domicilio_fonasa",           precision: 9, scale: 2
    t.decimal "consulta_no_urgencia_domicilio_no_fonasa",        precision: 9, scale: 2
    t.decimal "consulta_urgencia_domicilio_fonasa",              precision: 9, scale: 2
    t.decimal "consulta_urgencia_domicilio_no_fonasa",           precision: 9, scale: 2
    t.decimal "consulta_odontologica_fonasa",                    precision: 9, scale: 2
    t.decimal "consulta_odontologica_no_fonasa",                 precision: 9, scale: 2
    t.decimal "consulta_medico_de_referencia_fonasa",            precision: 9, scale: 2
    t.decimal "consulta_medico_de_referencia_no_fonasa",         precision: 9, scale: 2
    t.decimal "endoscopia_digestiva_endoscopia_fonasa",          precision: 9, scale: 2
    t.decimal "endoscopia_digestiva_endoscopia_no_fonasa",       precision: 9, scale: 2
    t.decimal "ecografia_simple_fonasa",                         precision: 9, scale: 2
    t.decimal "ecografia_simple_no_fonasa",                      precision: 9, scale: 2
    t.decimal "ecodoppler_fonasa",                               precision: 9, scale: 2
    t.decimal "ecodoppler_no_fonasa",                            precision: 9, scale: 2
    t.decimal "rx_simple_fonasa",                                precision: 9, scale: 2
    t.decimal "rx_simple_no_fonasa",                             precision: 9, scale: 2
    t.decimal "rx_torax_fonasa",                                 precision: 9, scale: 2
    t.decimal "rx_torax_no_fonasa",                              precision: 9, scale: 2
    t.decimal "rx_colorectal_fonasa",                            precision: 9, scale: 2
    t.decimal "rx_colorectal_no_fonasa",                         precision: 9, scale: 2
    t.decimal "resonancia_fonasa",                               precision: 9, scale: 2
    t.decimal "resonancia_no_fonasa",                            precision: 9, scale: 2
    t.decimal "tomografia_fonasa",                               precision: 9, scale: 2
    t.decimal "tomografia_no_fonasa",                            precision: 9, scale: 2
    t.decimal "laboratorio_rutina_basica_fonasa",                precision: 9, scale: 2
    t.decimal "laboratorio_rutina_basica_no_fonasa",             precision: 9, scale: 2
    t.decimal "tiempo_espera_medicina_general",                  precision: 9, scale: 2
    t.decimal "tiempo_espera_pediatria",                         precision: 9, scale: 2
    t.decimal "tiempo_espera_cirugia_general",                   precision: 9, scale: 2
    t.decimal "tiempo_espera_ginecotocologia",                   precision: 9, scale: 2
    t.decimal "tiempo_espera_cardiologia",                       precision: 9, scale: 2
    t.decimal "conformidad_disponibilidad_agenda_2014",          precision: 9, scale: 2
    t.decimal "conformidad_disponibilidad_agenda_2017",          precision: 9, scale: 2
    t.decimal "evaluacion_tiempo_espera_sala_2014",              precision: 9, scale: 2
    t.decimal "evaluacion_tiempo_espera_sala_2017",              precision: 9, scale: 2
    t.decimal "facilidad_para_realizar_tramites_gestiones_2014", precision: 9, scale: 2
    t.decimal "facilidad_para_realizar_tramites_gestiones_2017", precision: 9, scale: 2
    t.decimal "disponibilidad_medicamentos_farmacia_2017",       precision: 9, scale: 2
    t.decimal "informacion_sobre_derechos_2017",                 precision: 9, scale: 2
    t.decimal "queja_sugerencia_sabe_donde_dirigirse_2017",      precision: 9, scale: 2
    t.decimal "queja_sugerencia_sabe_donde_dirigirse_2014",      precision: 9, scale: 2
    t.decimal "satisfaccion_primer_nivel_atencion_2014",         precision: 9, scale: 2
    t.decimal "satisfaccion_primer_nivel_atencion_2017",         precision: 9, scale: 2
    t.decimal "satisfaccion_internacion_hospitalaria_2012",      precision: 9, scale: 2
    t.decimal "medicos_generales_policlinica",                   precision: 9, scale: 2
    t.decimal "medicos_de_familia_policlinica",                  precision: 9, scale: 2
    t.decimal "medicos_pediatras_policlinica",                   precision: 9, scale: 2
    t.decimal "medicos_ginecologos_policlinica",                 precision: 9, scale: 2
    t.decimal "auxiliares_enfermeria_policlinica",               precision: 9, scale: 2
    t.decimal "licenciadas_enfermeria_policlinica",              precision: 9, scale: 2
    t.decimal "cantidad_cad",                                    precision: 9, scale: 2
    t.decimal "medicina_general_cantidad_cad",                   precision: 9, scale: 2
    t.decimal "medicina_familiar_cantidad_cad",                  precision: 9, scale: 2
    t.decimal "pediatria_cantidad_cad",                          precision: 9, scale: 2
    t.decimal "ginecotologia_cantidad_cad",                      precision: 9, scale: 2
    t.decimal "medicina_interna_cantidad_cad",                   precision: 9, scale: 2
    t.decimal "medicina_intensiva_adultos_cantidad_cad",         precision: 9, scale: 2
    t.decimal "medicina_intensiva_pediatrica_cantidad_cad",      precision: 9, scale: 2
    t.decimal "neonatologia_cantidad_cad",                       precision: 9, scale: 2
    t.decimal "cantidad_cad_psiquiatria_adultos",                precision: 9, scale: 2
    t.decimal "cantidad_cad_psiquiatria_pediatrica",             precision: 9, scale: 2
    t.decimal "especialidades_medicas_cantidad_cad",             precision: 9, scale: 2
    t.decimal "cirugia_general_cantidad_cad",                    precision: 9, scale: 2
    t.decimal "medicina_emergencia_cantidad_cad",                precision: 9, scale: 2
    t.decimal "medicina_emergencia_pediatrica_cantidad_cad",     precision: 9, scale: 2
    t.integer "proporcion_trabajadores_seminario_2017"
    t.string  "reserva_presencial"
    t.string  "reserva_telefonica"
    t.string  "reserva_web"
    t.string  "reserva_consulta_medica"
    t.string  "realiza_recordatorio_cita"
    t.string  "realiza_caida_reserva_sin_confirmacion"
    t.string  "comunicacion_usuario_suspension_modificacion"
    t.boolean "private_insurance",                                                       default: false
    t.integer "estructura_primaria",                                                     default: 0
    t.integer "estructura_secundaria",                                                   default: 0
    t.integer "estructura_ambulatorio",                                                  default: 0
    t.integer "estructura_urgencia",                                                     default: 0
    t.string  "logo"
    t.string  "search_name"
    t.string  "vias_asignacion_citas"
    t.string  "espacio_adolescente"
    t.boolean "servicios_atencion_adolescentes"
    t.decimal "cantidad_cad_medicina_rural"
    t.decimal "cantidad_cad_imagenologia"
    t.decimal "cantidad_cad_anestesia"
    t.decimal "tiempo_espera_medicina_general_presencial"
    t.decimal "tiempo_espera_pediatria_presencial"
    t.decimal "tiempo_espera_cirugia_general_presencial"
    t.decimal "tiempo_espera_ginecotocologia_presencial"
    t.decimal "tiempo_espera_cardiologia_presencial"
    t.decimal "tiempo_espera_medicina_general_virtual"
    t.decimal "tiempo_espera_pediatria_virtual"
    t.decimal "tiempo_espera_cirugia_general_virtual"
    t.decimal "tiempo_espera_ginecotocologia_virtual"
    t.decimal "tiempo_espera_cardiologia_virtual"
  end

  create_table "recognitions", force: :cascade do |t|
    t.string  "recognition"
    t.integer "provider_id"
    t.string  "institution"
    t.integer "year"
    t.string  "practice"
    t.integer "icon"
    t.string  "link"
    t.string  "state"
  end

  create_table "sites", force: :cascade do |t|
    t.integer  "provider_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "direccion"
    t.string   "departamento"
    t.string   "localidad"
    t.string   "nivel"
    t.integer  "state_id"
  end

  add_index "sites", ["provider_id"], name: "index_sites_on_provider_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "intervention_types", "intervention_areas"
  add_foreign_key "interventions", "imaes"
  add_foreign_key "interventions", "intervention_types"
  add_foreign_key "interventions", "provider_fnrs"
  add_foreign_key "interventions", "providers"
  add_foreign_key "interventions", "states"
  add_foreign_key "provider_fnrs", "states"
  add_foreign_key "sites", "providers"
end
