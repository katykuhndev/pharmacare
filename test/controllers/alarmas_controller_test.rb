require 'test_helper'

class AlarmasControllerTest < ActionController::TestCase
  setup do
    @medicion = mediciones(:one)
    @alarma = alarmas(:one)
  end

  test "should get index" do
    get :index, params: { medicion_id: @medicion }
    assert_response :success
  end

  test "should get new" do
    get :new, params: { medicion_id: @medicion }
    assert_response :success
  end

  test "should create alarma" do
    assert_difference('Alarma.count') do
      post :create, params: { medicion_id: @medicion, alarma: @alarma.attributes }
    end

    assert_redirected_to medicion_alarma_path(@medicion, Alarma.last)
  end

  test "should show alarma" do
    get :show, params: { medicion_id: @medicion, id: @alarma }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { medicion_id: @medicion, id: @alarma }
    assert_response :success
  end

  test "should update alarma" do
    put :update, params: { medicion_id: @medicion, id: @alarma, alarma: @alarma.attributes }
    assert_redirected_to medicion_alarma_path(@medicion, Alarma.last)
  end

  test "should destroy alarma" do
    assert_difference('Alarma.count', -1) do
      delete :destroy, params: { medicion_id: @medicion, id: @alarma }
    end

    assert_redirected_to medicion_alarmas_path(@medicion)
  end
end
