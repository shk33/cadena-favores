require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should edit profiles tags" do
    tags = [ Tag.first.id , Tag.second.id ]
    patch :update, user_id: @user, id: @user.profile, profile: { tag_ids: tags }
    assert_redirected_to @user
  end
end
