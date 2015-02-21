require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should not create offer if service_request is closed" do
    closed_request  = service_requests(:closed)

    assert_no_difference 'Offer.count' do 
      post :create, offer: {}, service_request_id: closed_request.id
    end
    assert_redirected_to closed_request
  end

  test "should not create a valid offer if bidder and owner are the same" do
    service_request = service_requests(:one)

    assert_no_difference 'Offer.count' do 
      post :create, offer: {}, service_request_id: service_request.id
    end
    assert_redirected_to service_request
  end

  test "should create a valid offer" do
    service_request = service_requests(:two)

    assert_difference 'Offer.count', 1 do 
      post :create, offer: {}, service_request_id: service_request.id
    end
    assert_redirected_to service_request
  end

  test "should cancel a valid offer" do
    service_request = service_requests(:two)
    offer = offers(:one)

    assert_difference 'Offer.count', -1 do 
      delete :destroy, service_request_id: service_request.id, id: offer.id
    end
    assert_redirected_to service_request
  end

  test "should not cancel an offer on behalf of other user" do
    service_request = service_requests(:one)
    offer = offers(:two)

    assert_no_difference 'Offer.count' do 
      delete :destroy, service_request_id: service_request.id, id: offer.id
    end
    assert_redirected_to root_url
  end

end
