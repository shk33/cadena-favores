require 'test_helper'

class ServiceRequestDestroyerTest < ActiveSupport::TestCase
  def setup
    @user = users :main_user
  end

  test "should be a valid delete" do
    request = service_requests :one
    destroyer = ServiceRequestDestroyer.new request, @user
    assert destroyer.deleteable_request?
  end

  test "should not be a deleteable request if user is not owner" do
    request = service_requests :two
    destroyer = ServiceRequestDestroyer.new request, @user
    assert_not destroyer.deleteable_request?
  end

  test "should not be a deleteable request if request is closed" do
    request = service_requests :main_closed
    destroyer = ServiceRequestDestroyer.new request, @user
    assert_not destroyer.deleteable_request?
  end

  test "should delete a request and unfreeze points" do
    request = service_requests :one
    destroyer = ServiceRequestDestroyer.new request, @user
    assert destroyer.deleteable_request?

    assert_difference 'ServiceRequest.count', -1 do
      assert_difference 'Service.count', -1 do
        destroyer.destroy
      end
    end
    assert_equal 401, destroyer.user.balance.usable_points
    assert_equal 99 , destroyer.user.balance.frozen_points
  end

end