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
    log_in_as @user
    other_user = users(:one)
    get :show, id: other_user
    assert_response :success
    assert_select 'td', other_user.balance.usable_points.to_s
    assert_select 'td', other_user.balance.frozen_points.to_s
    assert_select 'td', other_user.balance.total_points.to_s
    assert_select 'td', other_user.hired_services_completed.count.to_s
    assert_select 'td', other_user.services_completed.count.to_s
    assert_select 'p',  other_user.profile.description
    other_user.profile.tags.each do |tag|
      assert_select 'button', tag.name
    end
  end

  test "should get edit if your are the current user" do
    log_in_as @user
    get :edit, id: @user
    assert_response :success
    assert_template :edit
  end

   test "should not get edit if you are not the current user" do
    log_in_as @user
    other_user = users(:one)
    get :edit, id: other_user
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not update user if user is wrong" do
    log_in_as @user
    other_user = users(:one)
    patch :update, id: other_user, user: { }
    assert_redirected_to root_url
  end

  test "should not update user with incomplete params" do
    log_in_as @user
    patch :update, id: @user, user: { name: "" }
    assert_template 'edit'
    assert_select 'div.alert'
  end

  test "should get my profile" do
    log_in_as @user
    get :my_profile
    assert_response :success
    assert_select 'td', @user.balance.usable_points.to_s
    assert_select 'td', @user.balance.frozen_points.to_s
    assert_select 'td', @user.balance.total_points.to_s
    assert_select 'td', @user.hired_services_completed.count.to_s
    assert_select 'td', @user.services_completed.count.to_s
    assert_select 'p',  @user.profile.description
    assert_select 'a[href=?]', edit_user_path(@user)
    @user.profile.tags.each do |tag|
      assert_select 'button', tag.name
    end
  end

  test "should get settings" do
    log_in_as @user
    get :settings
    assert_response :success
    assert_template :settings
    assert_select 'a[href=?]', user_path(@user), method: :delete
  end

end
