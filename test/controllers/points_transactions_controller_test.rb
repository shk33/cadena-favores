require 'test_helper'

class PointsTransactionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
  end

  test "should get index" do
    log_in_as @user
    get :index
    assert_response :success
  end
end
