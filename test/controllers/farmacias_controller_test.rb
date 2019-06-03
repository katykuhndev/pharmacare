require 'test_helper'

class FarmaciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @farmacia = farmacias(:one)
  end

  test "should get index" do
    get farmacias_url
    assert_response :success
  end

  test "should get new" do
    get new_farmacia_url
    assert_response :success
  end

  test "should create farmacia" do
    assert_difference('Farmacia.count') do
      post farmacias_url, params: { farmacia: { comuna_id: @farmacia.comuna_id, contacto: @farmacia.contacto, direccion: @farmacia.direccion, fono: @farmacia.fono, nombre: @farmacia.nombre, tipo: @farmacia.tipo } }
    end

    assert_redirected_to farmacia_url(Farmacia.last)
  end

  test "should show farmacia" do
    get farmacia_url(@farmacia)
    assert_response :success
  end

  test "should get edit" do
    get edit_farmacia_url(@farmacia)
    assert_response :success
  end

  test "should update farmacia" do
    patch farmacia_url(@farmacia), params: { farmacia: { comuna_id: @farmacia.comuna_id, contacto: @farmacia.contacto, direccion: @farmacia.direccion, fono: @farmacia.fono, nombre: @farmacia.nombre, tipo: @farmacia.tipo } }
    assert_redirected_to farmacia_url(@farmacia)
  end

  test "should destroy farmacia" do
    assert_difference('Farmacia.count', -1) do
      delete farmacia_url(@farmacia)
    end

    assert_redirected_to farmacias_url
  end
end
