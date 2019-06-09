json.extract! recomendacion, :id, :id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma, :created_at, :updated_at
json.url recomendacion_url(recomendacion, format: :json)
