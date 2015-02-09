require 'test_helper'

class UserDeleteAccountTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:main_user)
  end

  test "should delete your account" do
    log_in_as @user
    get settings_path
    assert_response :success
    assert_select 'a[href=?]', user_path(@user), method: :delete
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to site_root_url
  end
end
