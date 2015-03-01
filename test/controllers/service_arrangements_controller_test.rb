require 'test_helper'

class ServiceArrangementsControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should get hired" do
    get :hired
    assert_response :success
    arrangements = assigns :arrangements
    arrangements.each do |arrangement|
      assert_select "form", :action  => arrangement
    end
  end

  test "should not mark as completed if is not the client" do
    @arrangement = service_arrangements :three
    post :update, id: @arrangement
    assert_redirected_to root_url
  end

  test "should mark as completed if is the client" do
    @arrangement = service_arrangements :one
    post :update, id: @arrangement
    arrangement = assigns :service_arrangement
    assert arrangement.completed?
    assert_redirected_to my_hired_requests_url
  end

end
