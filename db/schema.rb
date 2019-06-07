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

ActiveRecord::Schema.define(version: 2019_06_05_025037) do

  create_table "alarmas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "medicion_id"
    t.string "nombre"
    t.decimal "valor_minimo", precision: 6, scale: 2
    t.decimal "valor_maximo", precision: 6, scale: 2
    t.text "accion"
    t.integer "resultado"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medicion_id"], name: "index_alarmas_on_medicion_id"
  end

  create_table "comunas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "documento_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.bigint "programa_id"
    t.integer "dias_vencimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["programa_id"], name: "index_documento_programas_on_programa_id"
  end

  create_table "examen_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "examen_id"
    t.bigint "programa_id"
    t.integer "dias_vencimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examen_id"], name: "index_examen_programas_on_examen_id"
    t.index ["programa_id"], name: "index_examen_programas_on_programa_id"
  end

  create_table "examenes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "farmacias", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "laboratorios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "fono"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_laboratorios_on_comuna_id"
  end

  create_table "medicamento_programas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "mediciones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "medicos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "pacientes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.index ["comuna_id"], name: "index_pacientes_on_comuna_id"
  end

  create_table "prestadores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.string "contacto"
    t.string "fono"
    t.text "direccion"
    t.bigint "comuna_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_prestadores_on_comuna_id"
  end

  create_table "programas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "regiones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  add_foreign_key "alarmas", "mediciones"
  add_foreign_key "comunas", "regiones"
  add_foreign_key "documento_programas", "programas"
  add_foreign_key "examen_programas", "examenes"
  add_foreign_key "examen_programas", "programas"
  add_foreign_key "farmacias", "comunas"
  add_foreign_key "laboratorios", "comunas"
  add_foreign_key "medicamento_programas", "programas"
  add_foreign_key "mediciones", "examenes"
  add_foreign_key "mediciones", "programas"
  add_foreign_key "medicos", "comunas"
  add_foreign_key "pacientes", "comunas"
  add_foreign_key "prestadores", "comunas"
  add_foreign_key "programas", "laboratorios"
end
