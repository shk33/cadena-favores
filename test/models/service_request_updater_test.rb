require 'test_helper'

class ServiceRequestUpdaterTest < ActiveSupport::TestCase
  def setup
    @service_request = service_requests :one
  end

  test "should be a valid update" do
    params = { :service_attributes =>{ :title => "Valid", :id => @service_request.service.id,
             :description => "Valid", :cost => "101"}, :tag_ids => []}
    updater = ServiceRequestUpdater.new @service_request, params
    assert updater.valid_update?
  end

  test "should update and freeze points surpluse" do
    params = { :service_attributes =>{ :title => "Valid", :id => @service_request.service.id,
             :description => "Valid", :cost => "101"}, :tag_ids => []}
    updater = ServiceRequestUpdater.new @service_request, params
    updater.update

    request = updater.service_request
    assert_equal "Valid", request.service.title
    assert_equal "Valid", request.service.description
    assert_equal 101    , request.service.cost
    
    user    = request.user
    assert_equal 300, user.balance.usable_points
    assert_equal 200, user.balance.frozen_points
  end

  test "should update and unfreeze points surpluse" do
    params = { :service_attributes =>{ :title => "Valid", :id => @service_request.service.id,
             :description => "Valid", :cost => "0"}, :tag_ids => []}
    updater = ServiceRequestUpdater.new @service_request, params
    updater.update

    request = updater.service_request
    assert_equal "Valid", request.service.title
    assert_equal "Valid", request.service.description
    assert_equal 0    , request.service.cost
    
    user    = request.user
    assert_equal 401, user.balance.usable_points
    assert_equal 99,  user.balance.frozen_points
  end

  test "should not update if user cannot pay points surpluse" do
    params = { :service_attributes =>{ :title => "Valid", :id => @service_request.service.id,
             :description => "Valid", :cost => "9999"}, :tag_ids => []}
    updater = ServiceRequestUpdater.new @service_request, params

    assert_not updater.valid_update?
  end

  test "should not update if cost is negative" do
    params = { :service_attributes =>{ :title => "Valid", :id => @service_request.service.id,
             :description => "Valid", :cost => "-9999"}, :tag_ids => []}
    updater = ServiceRequestUpdater.new @service_request, params

    assert_not updater.valid_update?
  end

end