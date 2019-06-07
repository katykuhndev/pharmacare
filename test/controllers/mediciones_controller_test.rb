require 'test_helper'

class MedicionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medicion = mediciones(:one)
  end

  test "should get index" do
    get mediciones_url
    assert_response :success
  end

  test "should get new" do
    get new_medicion_url
    assert_response :success
  end

  test "should create medicion" do
    assert_difference('Medicion.count') do
      post mediciones_url, params: { medicion: { descripcion: @medicion.descripcion, examen_id: @medicion.examen_id, nombre: @medicion.nombre, programa_id: @medicion.programa_id, unidad_medida: @medicion.unidad_medida } }
    end

    assert_redirected_to medicion_url(Medicion.last)
  end

  test "should show medicion" do
    get medicion_url(@medicion)
    assert_response :success
  end

  test "should get edit" do
    get edit_medicion_url(@medicion)
    assert_response :success
  end

  test "should update medicion" do
    patch medicion_url(@medicion), params: { medicion: { descripcion: @medicion.descripcion, examen_id: @medicion.examen_id, nombre: @medicion.nombre, programa_id: @medicion.programa_id, unidad_medida: @medicion.unidad_medida } }
    assert_redirected_to medicion_url(@medicion)
  end

  test "should destroy medicion" do
    assert_difference('Medicion.count', -1) do
      delete medicion_url(@medicion)
    end

    assert_redirected_to mediciones_url
  end
end
