require 'test_helper'

class InformesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get informes_index_url
    assert_response :success
  end

end
