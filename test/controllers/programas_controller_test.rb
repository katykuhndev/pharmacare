require 'test_helper'

class ProgramasControllerTest < ActionController::TestCase
  setup do
    @laboratorio = laboratorios(:one)
    @programa = programas(:one)
  end

  test "should get index" do
    get :index, params: { laboratorio_id: @laboratorio }
    assert_response :success
  end

  test "should get new" do
    get :new, params: { laboratorio_id: @laboratorio }
    assert_response :success
  end

  test "should create programa" do
    assert_difference('Programa.count') do
      post :create, params: { laboratorio_id: @laboratorio, programa: @programa.attributes }
    end

    assert_redirected_to laboratorio_programa_path(@laboratorio, Programa.last)
  end

  test "should show programa" do
    get :show, params: { laboratorio_id: @laboratorio, id: @programa }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { laboratorio_id: @laboratorio, id: @programa }
    assert_response :success
  end

  test "should update programa" do
    put :update, params: { laboratorio_id: @laboratorio, id: @programa, programa: @programa.attributes }
    assert_redirected_to laboratorio_programa_path(@laboratorio, Programa.last)
  end

  test "should destroy programa" do
    assert_difference('Programa.count', -1) do
      delete :destroy, params: { laboratorio_id: @laboratorio, id: @programa }
    end

    assert_redirected_to laboratorio_programas_path(@laboratorio)
  end
end
