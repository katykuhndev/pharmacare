require 'test_helper'

class CasosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caso = casos(:one)
  end

  test "should get index" do
    get casos_url
    assert_response :success
  end

  test "should get new" do
    get new_caso_url
    assert_response :success
  end

  test "should create caso" do
    assert_difference('Caso.count') do
      post casos_url, params: { caso: { codigo: @caso.codigo, ejecutivo_id: @caso.ejecutivo_id, fecha_hora_cierre: @caso.fecha_hora_cierre, fecha_hora_ingreso: @caso.fecha_hora_ingreso, medico_id: @caso.medico_id, observaciones: @caso.observaciones, paciente_id: @caso.paciente_id, programa_id: @caso.programa_id, qf_soporte_id: @caso.qf_soporte_id, via_ingreso: @caso.via_ingreso } }
    end

    assert_redirected_to caso_url(Caso.last)
  end

  test "should show caso" do
    get caso_url(@caso)
    assert_response :success
  end

  test "should get edit" do
    get edit_caso_url(@caso)
    assert_response :success
  end

  test "should update caso" do
    patch caso_url(@caso), params: { caso: { codigo: @caso.codigo, ejecutivo_id: @caso.ejecutivo_id, fecha_hora_cierre: @caso.fecha_hora_cierre, fecha_hora_ingreso: @caso.fecha_hora_ingreso, medico_id: @caso.medico_id, observaciones: @caso.observaciones, paciente_id: @caso.paciente_id, programa_id: @caso.programa_id, qf_soporte_id: @caso.qf_soporte_id, via_ingreso: @caso.via_ingreso } }
    assert_redirected_to caso_url(@caso)
  end

  test "should destroy caso" do
    assert_difference('Caso.count', -1) do
      delete caso_url(@caso)
    end

    assert_redirected_to casos_url
  end
end
