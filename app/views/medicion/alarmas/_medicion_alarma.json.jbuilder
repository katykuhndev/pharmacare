json.extract! medicion_alarma, :id, :nombre, :valor_minimo, :valor_maximo, :accion, :resultado, :observaciones, :created_at, :updated_at
json.url medicion_alarma_url(medicion_alarma, format: :json)
