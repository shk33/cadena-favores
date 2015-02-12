require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should get index" do
    get :index
    assert_select 'h2', "Notificaciones"
    assert_response :success
  end

end
