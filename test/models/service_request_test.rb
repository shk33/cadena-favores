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
 
end
