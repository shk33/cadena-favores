require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
  end

  test "should get index" do
    # get :index
    # assert_response :success
    # assert_not_nil assigns(:users)
  end

  test "should show user" do
    # get :show, id: @user
    # assert_response :success
  end

  test "should get edit" do
    # get :edit, id: @user
    # assert_response :success
  end

  test "should update user" do
    # patch :update, id: @user, user: { email: @user.email, name: @user.name, password_digest: @user.password_digest, remember_digest: @user.remember_digest }
    # assert_redirected_to user_path(assigns(:user))
  end

  test "should get settings" do
    log_in_as @user
    get :settings
    assert_response :success
    assert_template :settings
    #assert_select 'a[href=?]', user_path(@user), method: :delete
  end

end
