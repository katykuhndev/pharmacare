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

ActiveRecord::Schema.define(version: 2020_03_10_021036) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "alarmas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "medicion_id"
    t.string "nombre"
    t.decimal "valor_minimo", precision: 6, scale: 2
    t.decimal "valor_maximo", precision: 10, scale: 2
    t.text "accion"
    t.integer "resultado"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["medicion_id"], name: "index_alarmas_on_medicion_id"
  end

  create_table "bloques", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.time "inicio"
    t.time "fin"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "esquema_horario_id"
    t.index ["esquema_horario_id"], name: "index_bloques_on_esquema_horario_id"
  end

  create_table "bloques_programas", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "bloque_id", null: false
    t.bigint "programa_id", null: false
  end

  create_table "casos", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "codigo"
    t.bigint "programa_id"
    t.bigint "medico_id"
    t.bigint "paciente_id"
    t.integer "qf_soporte_id"
    t.integer "ejecutivo_id"
    t.datetime "fecha_hora_ingreso"
    t.integer "via_ingreso"
    t.datetime "fecha_hora_cierre"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tipo_control_id"
    t.index ["medico_id"], name: "index_casos_on_medico_id"
    t.index ["paciente_id"], name: "index_casos_on_paciente_id"
    t.index ["programa_id"], name: "index_casos_on_programa_id"
    t.index ["tipo_control_id"], name: "index_casos_on_tipo_control_id"
  end

  create_table "comunas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "documento_casos", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.bigint "caso_id"
    t.bigint "documento_programa_id"
    t.integer "ejecutivo_id"
    t.datetime "fecha"
    t.text "observaciones"
    t.date "fecha_vencimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caso_id"], name: "index_documento_casos_on_caso_id"
    t.index ["documento_programa_id"], name: "index_documento_casos_on_documento_programa_id"
  end

  create_table "documento_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.bigint "programa_id"
    t.integer "dias_vencimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "asociado_caso", default: false
    t.index ["programa_id"], name: "index_documento_programas_on_programa_id"
  end

  create_table "documento_recomendaciones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.bigint "recomendacion_id"
    t.bigint "documento_programa_id"
    t.integer "ejecutivo_id"
    t.datetime "fecha"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_vencimiento"
    t.index ["documento_programa_id"], name: "index_documento_recomendaciones_on_documento_programa_id"
    t.index ["recomendacion_id"], name: "index_documento_recomendaciones_on_recomendacion_id"
  end

  create_table "esquema_horarios", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "esquema_tratamientos", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "recomendacion_id"
    t.bigint "tratamiento_id"
    t.bigint "bloque_id"
    t.decimal "dosis", precision: 6, scale: 2
    t.string "unidad_medida"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bloque_id"], name: "index_esquema_tratamientos_on_bloque_id"
    t.index ["recomendacion_id"], name: "index_esquema_tratamientos_on_recomendacion_id"
    t.index ["tratamiento_id"], name: "index_esquema_tratamientos_on_tratamiento_id"
  end

  create_table "examen_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "examen_id"
    t.bigint "programa_id"
    t.integer "dias_vencimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tipo_control_id"
    t.index ["examen_id"], name: "index_examen_programas_on_examen_id"
    t.index ["programa_id"], name: "index_examen_programas_on_programa_id"
    t.index ["tipo_control_id"], name: "index_examen_programas_on_tipo_control_id"
  end

  create_table "examen_recomendaciones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.bigint "recomendacion_id"
    t.bigint "examen_programa_id"
    t.integer "ejecutivo_id"
    t.datetime "fecha"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_vencimiento"
    t.index ["examen_programa_id"], name: "index_examen_recomendaciones_on_examen_programa_id"
    t.index ["recomendacion_id"], name: "index_examen_recomendaciones_on_recomendacion_id"
  end

  create_table "examenes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "farmacias", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "fono"
    t.text "direccion"
    t.bigint "comuna_id"
    t.integer "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_farmacias_on_comuna_id"
  end

  create_table "laboratorios", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "fono"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_laboratorios_on_comuna_id"
  end

  create_table "medicamento_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "programa_id"
    t.string "nombre_comercial"
    t.string "principio_activo"
    t.decimal "dosis", precision: 6, scale: 2
    t.string "unidad_medida"
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["programa_id"], name: "index_medicamento_programas_on_programa_id"
  end

  create_table "medicion_recomendaciones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "recomendacion_id"
    t.bigint "medicion_id"
    t.decimal "valor", precision: 10, scale: 2
    t.string "unidad_medida"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medicion_id"], name: "index_medicion_recomendaciones_on_medicion_id"
    t.index ["recomendacion_id"], name: "index_medicion_recomendaciones_on_recomendacion_id"
  end

  create_table "mediciones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.bigint "programa_id"
    t.bigint "examen_id"
    t.string "unidad_medida"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examen_id"], name: "index_mediciones_on_examen_id"
    t.index ["programa_id"], name: "index_mediciones_on_programa_id"
  end

  create_table "medico_temporal", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "fecha_inicio"
  end

  create_table "medicos", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombres"
    t.string "primer_apellido"
    t.string "segundo_apellido"
    t.string "rut"
    t.integer "genero"
    t.date "fecha_nacimiento"
    t.string "fono1"
    t.string "fono2"
    t.string "email"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_medicos_on_comuna_id"
  end

  create_table "medicos_rut", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombres"
    t.string "primer_apellido"
    t.string "segundo_apellido"
    t.string "rut"
    t.integer "medico_id"
  end

  create_table "paciente_formateado", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "id_paciente"
    t.string "codigo_paciente"
    t.string "nombre"
    t.string "ap_paterno"
    t.string "ap_materno"
    t.string "rut"
    t.string "fecha_consentimiento"
    t.string "consentimiento"
    t.string "fecha_nacimiento"
    t.string "edad"
    t.string "domicilio"
    t.string "comuna"
  end

  create_table "paciente_temporal", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "id_paciente"
    t.string "codigo_paciente"
    t.string "nombre"
    t.string "ap_paterno"
    t.string "ap_materno"
    t.string "nombre_paciente_completo"
    t.string "fecha_ingreso"
    t.string "rut"
    t.string "fecha_consentimiento"
  end

  create_table "paciente_temporal_antigua", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "paciente_id"
    t.string "codigo_paciente"
    t.string "nombres"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.string "rut"
    t.string "fecha_consentimiento"
    t.string "ci"
    t.string "fecha_nacimiento"
    t.string "edad_2019"
    t.string "domicilio"
    t.string "comuna"
  end

  create_table "pacientes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombres"
    t.string "primer_apellido"
    t.string "segundo_apellido"
    t.string "rut"
    t.integer "genero"
    t.date "fecha_nacimiento"
    t.string "fono1"
    t.string "fono2"
    t.string "email"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "id_paciente"
    t.index ["comuna_id"], name: "index_pacientes_on_comuna_id"
  end

  create_table "prestadores", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "fono"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_prestadores_on_comuna_id"
  end

  create_table "programas", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "laboratorio_id"
    t.string "nombre"
    t.text "descripcion"
    t.datetime "fecha_creacion"
    t.bigint "qf_soporte_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["laboratorio_id"], name: "index_programas_on_laboratorio_id"
    t.index ["qf_soporte_id"], name: "index_programas_on_qf_soporte_id"
  end

  create_table "recomendacion_temporal", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "id_recomendacion"
    t.string "hemograma"
    t.string "receta"
    t.string "consentimiento"
    t.string "tipo_alerta"
    t.string "autorizacion"
    t.string "motivo_rechazo"
    t.string "fecha_recomendacion"
    t.string "mes_recomendacion"
    t.string "codigo_paciente"
    t.string "id_paciente"
    t.string "nombre_paciente"
    t.string "ap_paterno"
    t.string "ap_materno"
    t.string "rut"
    t.string "fecha_receta"
    t.string "prestador"
    t.string "receta_aceptada"
    t.string "fecha_hemograma"
    t.string "leucocitos"
    t.string "baciliformes"
    t.string "segmentados"
    t.string "RAN"
    t.string "hemograma_aceptado"
    t.string "medico_tratante"
    t.string "cadena"
    t.string "QF"
    t.string "detalle_alarma"
    t.string "comentario"
    t.string "presentacion"
    t.string "manana"
    t.string "tarde"
    t.string "noche"
    t.string "dias_tratamiento"
    t.string "cantidad"
    t.string "ejecutivo"
    t.string "presentacion2"
    t.string "manana2"
    t.string "tarde2"
    t.string "noche2"
    t.string "dias_tratamiento2"
    t.string "cantidad2"
    t.integer "qf_soporte_id"
    t.integer "ejecutivo_id"
    t.integer "medico_id"
    t.integer "farmacia_id"
    t.integer "prestador_id"
    t.integer "paciente_id"
    t.integer "caso_id"
    t.integer "estado"
    t.integer "resultado"
    t.integer "con_alarma"
    t.integer "resolucion_qf"
    t.datetime "fecha_hora_ingreso"
    t.datetime "fecha_hora_respuesta"
    t.integer "via_ingreso"
    t.integer "recomendacion_id"
    t.integer "programa_id"
    t.integer "alarma_id"
  end

  create_table "recomendaciones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "id_recomendacion"
    t.integer "estado"
    t.integer "resultado"
    t.bigint "caso_id"
    t.bigint "programa_id"
    t.bigint "paciente_id"
    t.bigint "medico_id"
    t.bigint "prestador_id"
    t.bigint "farmacia_id"
    t.integer "qf_soporte_id"
    t.integer "ejecutivo_id"
    t.datetime "fecha_hora_ingreso"
    t.integer "via_ingreso"
    t.datetime "fecha_hora_respuesta"
    t.text "observaciones"
    t.boolean "con_alarma"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "alarma_id"
    t.integer "resolucion_qf"
    t.text "comentarios"
    t.text "motivo_rechazo"
    t.index ["alarma_id"], name: "index_recomendaciones_on_alarma_id"
    t.index ["caso_id"], name: "index_recomendaciones_on_caso_id"
    t.index ["farmacia_id"], name: "index_recomendaciones_on_farmacia_id"
    t.index ["medico_id"], name: "index_recomendaciones_on_medico_id"
    t.index ["paciente_id"], name: "index_recomendaciones_on_paciente_id"
    t.index ["prestador_id"], name: "index_recomendaciones_on_prestador_id"
    t.index ["programa_id"], name: "index_recomendaciones_on_programa_id"
  end

  create_table "regiones", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_controles", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.integer "dias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tratamientos", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "recomendacion_id"
    t.integer "dias"
    t.integer "cantidad"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "medicamento_programa_id"
    t.integer "documento_recomendacion_id"
    t.bigint "esquema_horario_id"
    t.index ["esquema_horario_id"], name: "index_tratamientos_on_esquema_horario_id"
    t.index ["recomendacion_id"], name: "index_tratamientos_on_recomendacion_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alarmas", "mediciones"
  add_foreign_key "bloques", "esquema_horarios"
  add_foreign_key "casos", "medicos"
  add_foreign_key "casos", "pacientes"
  add_foreign_key "casos", "programas"
  add_foreign_key "casos", "tipo_controles"
  add_foreign_key "comunas", "regiones"
  add_foreign_key "documento_casos", "casos"
  add_foreign_key "documento_casos", "documento_programas"
  add_foreign_key "documento_programas", "programas"
  add_foreign_key "documento_recomendaciones", "documento_programas"
  add_foreign_key "documento_recomendaciones", "recomendaciones"
  add_foreign_key "esquema_tratamientos", "bloques"
  add_foreign_key "esquema_tratamientos", "recomendaciones"
  add_foreign_key "esquema_tratamientos", "tratamientos"
  add_foreign_key "examen_programas", "examenes"
  add_foreign_key "examen_programas", "programas"
  add_foreign_key "examen_programas", "tipo_controles"
  add_foreign_key "examen_recomendaciones", "examen_programas"
  add_foreign_key "examen_recomendaciones", "recomendaciones"
  add_foreign_key "farmacias", "comunas"
  add_foreign_key "laboratorios", "comunas"
  add_foreign_key "medicamento_programas", "programas"
  add_foreign_key "medicion_recomendaciones", "mediciones"
  add_foreign_key "medicion_recomendaciones", "recomendaciones"
  add_foreign_key "mediciones", "examenes"
  add_foreign_key "mediciones", "programas"
  add_foreign_key "medicos", "comunas"
  add_foreign_key "pacientes", "comunas"
  add_foreign_key "prestadores", "comunas"
  add_foreign_key "programas", "laboratorios"
  add_foreign_key "recomendaciones", "alarmas"
  add_foreign_key "recomendaciones", "casos"
  add_foreign_key "recomendaciones", "farmacias"
  add_foreign_key "recomendaciones", "medicos"
  add_foreign_key "recomendaciones", "pacientes"
  add_foreign_key "recomendaciones", "prestadores"
  add_foreign_key "recomendaciones", "programas"
  add_foreign_key "tratamientos", "esquema_horarios"
  add_foreign_key "tratamientos", "recomendaciones"
end
