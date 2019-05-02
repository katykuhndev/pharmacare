require 'test_helper'

class PacientesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @paciente = pacientes(:one)
  end

  test "should get index" do
    get pacientes_url
    assert_response :success
  end

  test "should get new" do
    get new_paciente_url
    assert_response :success
  end

  test "should create paciente" do
    assert_difference('Paciente.count') do
      post pacientes_url, params: { paciente: { comuna_id: @paciente.comuna_id, direccion: @paciente.direccion, email: @paciente.email, fecha_nacimiento: @paciente.fecha_nacimiento, fono1: @paciente.fono1, fono2: @paciente.fono2, genero: @paciente.genero, nombres: @paciente.nombres, primer_apellido: @paciente.primer_apellido, rut: @paciente.rut, segundo_apellido: @paciente.segundo_apellido } }
    end

    assert_redirected_to paciente_url(Paciente.last)
  end

  test "should show paciente" do
    get paciente_url(@paciente)
    assert_response :success
  end

  test "should get edit" do
    get edit_paciente_url(@paciente)
    assert_response :success
  end

  test "should update paciente" do
    patch paciente_url(@paciente), params: { paciente: { comuna_id: @paciente.comuna_id, direccion: @paciente.direccion, email: @paciente.email, fecha_nacimiento: @paciente.fecha_nacimiento, fono1: @paciente.fono1, fono2: @paciente.fono2, genero: @paciente.genero, nombres: @paciente.nombres, primer_apellido: @paciente.primer_apellido, rut: @paciente.rut, segundo_apellido: @paciente.segundo_apellido } }
    assert_redirected_to paciente_url(@paciente)
  end

  test "should destroy paciente" do
    assert_difference('Paciente.count', -1) do
      delete paciente_url(@paciente)
    end

    assert_redirected_to pacientes_url
  end
end
