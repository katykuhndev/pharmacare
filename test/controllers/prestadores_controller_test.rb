require 'test_helper'

class PrestadoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prestador = prestadores(:one)
  end

  test "should get index" do
    get prestadores_url
    assert_response :success
  end

  test "should get new" do
    get new_prestador_url
    assert_response :success
  end

  test "should create prestador" do
    assert_difference('Prestador.count') do
      post prestadores_url, params: { prestador: { comuna_id: @prestador.comuna_id, contacto: @prestador.contacto, direccion: @prestador.direccion, fono: @prestador.fono, nombre: @prestador.nombre } }
    end

    assert_redirected_to prestador_url(Prestador.last)
  end

  test "should show prestador" do
    get prestador_url(@prestador)
    assert_response :success
  end

  test "should get edit" do
    get edit_prestador_url(@prestador)
    assert_response :success
  end

  test "should update prestador" do
    patch prestador_url(@prestador), params: { prestador: { comuna_id: @prestador.comuna_id, contacto: @prestador.contacto, direccion: @prestador.direccion, fono: @prestador.fono, nombre: @prestador.nombre } }
    assert_redirected_to prestador_url(@prestador)
  end

  test "should destroy prestador" do
    assert_difference('Prestador.count', -1) do
      delete prestador_url(@prestador)
    end

    assert_redirected_to prestadores_url
  end
end
