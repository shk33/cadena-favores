require 'test_helper'

class ServiceRequestCreationTest < ActiveSupport::TestCase
  def setup
    @user = users :main_user
    params = { :service_attributes =>{ :title => "Valid",
               :description => "Valid", :cost => "100"}, :tag_ids => []}
    @creator = ServiceRequestCreation.new  params, @user
  end

  test "should be a valid creation" do
    assert @creator.valid_creation?
  end

  test "should create and freeze points" do
    assert_difference 'ServiceRequest.count', 1 do
      assert_difference 'Service.count', 1 do
        @creator.create
      end  
    end
    request = @creator.service_request
    assert_equal "Valid", request.service.title
    assert_equal "Valid", request.service.description
    assert_equal 100    , request.service.cost
    assert_equal []     , request.tag_ids

    user = @creator.user
    assert_equal 300, user.balance.usable_points
    assert_equal 200, user.balance.frozen_points
  end

end