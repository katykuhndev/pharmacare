json.extract! medicion, :id, :nombre, :descripcion, :programa_id, :examen_id, :unidad_medida, :created_at, :updated_at
json.url medicion_url(medicion, format: :json)
