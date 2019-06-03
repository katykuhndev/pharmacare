json.extract! prestador, :id, :nombre, :contacto, :fono, :direccion, :comuna_id, :created_at, :updated_at
json.url prestador_url(prestador, format: :json)
