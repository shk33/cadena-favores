require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end

  test "should post to relationships" do
    user = users(:main_user)
    log_in_as user
    user_one = users :one
    assert_difference 'Relationship.count', 1 do
      post :create , followed_id: user_one.id
    end
    assert_redirected_to user_one
  end

  test "should delete a new relationship" do
    # user = users(:main_user)
    # user_one = users :one
    # log_in_as user
    # assert_difference 'Relationship.count', -1 do
    #   delete :destroy , id: user_one.id
    # end
    # assert_redirected_to user_one
  end

end
