require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
  end

  test "should get index" do
    log_in_as @user
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    #Asserting advanced search form
    assert_select 'label', 'Busqueda por nombre'
    assert_select "input", :name  => "commit", :type => "submit",:value => 'Buscar'
  end

  test "should get following" do
    log_in_as @user
    get :following, id: @user.id
    assert_response :success
  end

  test "should get index and search by name" do
    log_in_as @user
    other_user = users(:one)
    get :index , search: "User One", search_type: 1
    assert_response :success
    assert_select 'a', other_user.name
  end

  test "should get index and search by tags" do
    log_in_as @user
    other_user = users(:one)
    tag = tags(:programacion)
    get :index , tag: tag.id, search_type: 2
    assert_response :success
    assert_select 'a', other_user.name
    assert_select 'span', tag.name
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

  test "should update user" do
    log_in_as @user
    tags = [ Tag.first.id , Tag.second.id ]
    patch :update, id: @user, user: { name:  "The mighty Admin",
                                      email: "admin@admin1.com",
                                      password:              "1234567",
                                      password_confirmation: "1234567",
                                      profile_attributes: {
                                        id: @user.profile.id,
                                        description: "Esta es una nueva",
                                        tag_ids: tags
                                      } }
    assert_redirected_to @user
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
    
  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

end
