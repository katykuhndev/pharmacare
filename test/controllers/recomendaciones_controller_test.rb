require 'test_helper'

class RecomendacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recomendacion = recomendaciones(:one)
  end

  test "should get index" do
    get recomendaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_recomendacion_url
    assert_response :success
  end

  test "should create recomendacion" do
    assert_difference('Recomendacion.count') do
      post recomendaciones_url, params: { recomendacion: { caso_id: @recomendacion.caso_id, con_alarma: @recomendacion.con_alarma, ejecutivo_id: @recomendacion.ejecutivo_id, estado: @recomendacion.estado, farmacia_id: @recomendacion.farmacia_id, fecha_hora_ingreso: @recomendacion.fecha_hora_ingreso, fecha_hora_respuesta: @recomendacion.fecha_hora_respuesta, id_recomendacion: @recomendacion.id_recomendacion, medico_id: @recomendacion.medico_id, observaciones: @recomendacion.observaciones, paciente_id: @recomendacion.paciente_id, prestador_id: @recomendacion.prestador_id, programa_id: @recomendacion.programa_id, qf_soporte_id: @recomendacion.qf_soporte_id, resultado: @recomendacion.resultado, via_ingreso: @recomendacion.via_ingreso } }
    end

    assert_redirected_to recomendacion_url(Recomendacion.last)
  end

  test "should show recomendacion" do
    get recomendacion_url(@recomendacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_recomendacion_url(@recomendacion)
    assert_response :success
  end

  test "should update recomendacion" do
    patch recomendacion_url(@recomendacion), params: { recomendacion: { caso_id: @recomendacion.caso_id, con_alarma: @recomendacion.con_alarma, ejecutivo_id: @recomendacion.ejecutivo_id, estado: @recomendacion.estado, farmacia_id: @recomendacion.farmacia_id, fecha_hora_ingreso: @recomendacion.fecha_hora_ingreso, fecha_hora_respuesta: @recomendacion.fecha_hora_respuesta, id_recomendacion: @recomendacion.id_recomendacion, medico_id: @recomendacion.medico_id, observaciones: @recomendacion.observaciones, paciente_id: @recomendacion.paciente_id, prestador_id: @recomendacion.prestador_id, programa_id: @recomendacion.programa_id, qf_soporte_id: @recomendacion.qf_soporte_id, resultado: @recomendacion.resultado, via_ingreso: @recomendacion.via_ingreso } }
    assert_redirected_to recomendacion_url(@recomendacion)
  end

  test "should destroy recomendacion" do
    assert_difference('Recomendacion.count', -1) do
      delete recomendacion_url(@recomendacion)
    end

    assert_redirected_to recomendaciones_url
  end
end
