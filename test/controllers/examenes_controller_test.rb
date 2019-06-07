require 'test_helper'

class ExamenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @examen = examenes(:one)
  end

  test "should get index" do
    get examenes_url
    assert_response :success
  end

  test "should get new" do
    get new_examen_url
    assert_response :success
  end

  test "should create examen" do
    assert_difference('Examen.count') do
      post examenes_url, params: { examen: { descripcion: @examen.descripcion, nombre: @examen.nombre } }
    end

    assert_redirected_to examen_url(Examen.last)
  end

  test "should show examen" do
    get examen_url(@examen)
    assert_response :success
  end

  test "should get edit" do
    get edit_examen_url(@examen)
    assert_response :success
  end

  test "should update examen" do
    patch examen_url(@examen), params: { examen: { descripcion: @examen.descripcion, nombre: @examen.nombre } }
    assert_redirected_to examen_url(@examen)
  end

  test "should destroy examen" do
    assert_difference('Examen.count', -1) do
      delete examen_url(@examen)
    end

    assert_redirected_to examenes_url
  end
end
