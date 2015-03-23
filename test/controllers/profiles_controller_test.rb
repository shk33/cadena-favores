require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should edit profiles tags" do
    tags = [ Tag.first.id , Tag.second.id ]
    patch :update, user_id: @user, id: @user.profile, profile: { tag_ids: tags }
    profile = assigns :profile
    assert_equal profile.tag_ids, tags
    assert_redirected_to @user
  end

  test "should not edit profiles tags is profile do not belong to current user" do
    user = users :one
    tags = [ Tag.first.id , Tag.second.id ]
    patch :update, user_id: user, id: @user.profile, profile: { tag_ids: tags }
    assert_redirected_to root_url
  end
end
