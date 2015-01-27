require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:main_user)
  end

  ##########################################
  # Cannot log in when user already logged in
  ##########################################

  test "try to get login form redirecto to main app when already logged in" do
    log_in_as @user
    get login_path
    assert_response :redirect
    assert_redirected_to root_url
  end

  ##########################################
  # Test logged in when not logged in yet
  ##########################################

  test "try to log in with invalid info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "", password: ""}
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "test log in with valid info follow by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "main_user@example.com",
                               password: "password"}
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'home/index'
    delete logout_path
    assert_redirected_to site_root_url
    follow_redirect!
    assert_template 'site/index'
  end

  test "login with remembering" do
    log_in_as @user, remember_me: '1'
    assert_equal assigns(:user).remember_token, cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as @user, remember_me: '0'
    assert_nil cookies['remember_token']
  end

end
