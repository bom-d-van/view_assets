require 'test_helper'

class CuttingRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get cutting_calculate" do
    get :cutting_calculate
    assert_response :success
  end

end
