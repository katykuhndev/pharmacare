require 'test_helper'

class MedicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medico = medicos(:one)
  end

  test "should get index" do
    get medicos_url
    assert_response :success
  end

  test "should get new" do
    get new_medico_url
    assert_response :success
  end

  test "should create medico" do
    assert_difference('Medico.count') do
      post medicos_url, params: { medico: { comuna_id: @medico.comuna_id, direccion: @medico.direccion, email: @medico.email, fecha_nacimiento: @medico.fecha_nacimiento, fono1: @medico.fono1, fono2: @medico.fono2, genero: @medico.genero, nombres: @medico.nombres, primer_apellido: @medico.primer_apellido, rut: @medico.rut, segundo_apellido: @medico.segundo_apellido } }
    end

    assert_redirected_to medico_url(Medico.last)
  end

  test "should show medico" do
    get medico_url(@medico)
    assert_response :success
  end

  test "should get edit" do
    get edit_medico_url(@medico)
    assert_response :success
  end

  test "should update medico" do
    patch medico_url(@medico), params: { medico: { comuna_id: @medico.comuna_id, direccion: @medico.direccion, email: @medico.email, fecha_nacimiento: @medico.fecha_nacimiento, fono1: @medico.fono1, fono2: @medico.fono2, genero: @medico.genero, nombres: @medico.nombres, primer_apellido: @medico.primer_apellido, rut: @medico.rut, segundo_apellido: @medico.segundo_apellido } }
    assert_redirected_to medico_url(@medico)
  end

  test "should destroy medico" do
    assert_difference('Medico.count', -1) do
      delete medico_url(@medico)
    end

    assert_redirected_to medicos_url
  end
end
