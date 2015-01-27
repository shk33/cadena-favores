require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  ##########################################
  # Signups should be invalid when logged in
  ##########################################

  test "should signup redirect to main app when logged in" do
    log_in_as @user
    get signup_path
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should reject signup valid information when logged in" do
    log_in_as @user
    assert_no_difference 'User.count' do
      post signup_path, user: { name:  "Valida Name",
                                 email: "user@valid.com",
                                 password:              "123456",
                                 password_confirmation: "123456" }
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  #######################################
  # Signup when not logged in
  #######################################
  test "should reject signup invalid information" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post signup_path, user: { name:  "V",
                                 email: ".com",
                                 password:              "123456",
                                 password_confirmation: "123456" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "should reject signup with repeated email" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post signup_path, user: { name:  "Valid Name",
                                 email: "main_user@example.com",
                                 password:              "123456",
                                 password_confirmation: "123456" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
  end

  test "valid signup information" do
    get signup_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post signup_path, user: { name:  "Valid Name",
                                 email: "valid@valid.com",
                                 password:              "123456",
                                 password_confirmation: "123456" }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'home/index'
  end

end
