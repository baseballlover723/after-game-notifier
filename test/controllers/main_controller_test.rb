require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get individual" do
    get :individual, region: "NA", username: "username"
    assert_response :success
  end

end
