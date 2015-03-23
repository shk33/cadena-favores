require 'test_helper'

class RequiredServiceTest < ActiveSupport::TestCase
  def setup
    @service_request = ServiceRequest.new
    @service_request.service = Service.new title: "Valid title", description: "valid description" ,
            cost: "100"
    @service_request.user = users(:main_user)
  end

  test "should be valid" do
    assert @service_request.valid?
  end

  test "should have a service" do
    @service_request.service = nil
    assert_not @service_request.valid?
  end
 
   test "should get all request when tag is not provided in search" do
    assert_equal ServiceRequest.search_by_tag(nil), ServiceRequest.all
   end

   test "has accepted offer method" do
     request = service_requests :closed
     assert_not request.has_accepted_offer?
   end

   test "accepted_offer should return only one offer" do
     request = service_requests :one
     offer = offers :five
     assert_equal offer, request.accepted_offer
   end
end
