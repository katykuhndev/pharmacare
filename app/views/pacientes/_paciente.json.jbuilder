json.extract! paciente, :id, :nombres, :primer_apellido, :segundo_apellido, :rut, :genero, :fecha_nacimiento, :fono1, :fono2, :email, :direccion, :comuna_id, :created_at, :updated_at
json.url paciente_url(paciente, format: :json)
