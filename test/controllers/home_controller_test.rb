require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def setup
    @user = users(:main_user)
  end

  test "should get principal home page" do
    log_in_as @user
    get :index
    assert_response :success
    assert_template 'index'
    assert_select "title", 'Cadena de Favores'
  end

  test "should redirect index when not logged in" do
    get :index
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
  end
end
