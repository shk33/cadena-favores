require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

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

end
