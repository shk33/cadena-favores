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

  test "should get new_accept if is user is owner" do
    offer = offers :one
    request = service_requests :one
    get :new_accept ,service_request_id: request, id: offer
    assert_template :new_accept
    assert_select "input", id: "service_arrangement_start_date", type: "date"
    assert_select "input", id: "service_arrangement_end_date", type: "date"
  end

  test "should not get new_accept when user is not owner" do
    offer = offers :three
    request = service_requests :two
    get :new_accept ,service_request_id: request, id: offer
    assert_redirected_to root_url
  end

  test "should not post to accept if is not owner" do
    offer = offers :three
    request = service_requests :two
    assert_no_difference 'ServiceArrangement.count' do
      post :accept ,service_request_id: request, id: offer
    end
    assert_redirected_to root_url
  end

  test "should not post to accept if offer params are invalid" do
    offer = offers :one
    request = service_requests :one
    assert_no_difference 'ServiceArrangement.count' do
      post :accept ,service_request_id: request, id: offer
    end
  end

  test "should not post to accept if request is closed" do
    offer = offers :four
    request = service_requests :main_closed
    assert_no_difference 'ServiceArrangement.count' do
      post :accept ,service_request_id: request, id: offer
    end
    assert_redirected_to root_url
  end

  test "should not post to accept with invalid info" do
    offer = offers :two
    request = service_requests :one
    assert_no_difference 'ServiceArrangement.count' do
      post :accept ,service_request_id: request, id: offer,
           service_arrangement: {start_date: nil, end_date: nil}
    end
    assert_template :new_accept
  end

  test "should not post to accept if dates are invalid" do
    offer = offers :two
    request = service_requests :one
    assert_no_difference 'ServiceArrangement.count' do
      post :accept ,service_request_id: request, id: offer,
          service_arrangement: {start_date: Date.today - 1, end_date: Date.today - 2}
    end
    assert_template :new_accept
  end

  test "should post to accept" do
    offer = offers :two
    request = service_requests :one
    post :accept ,service_request_id: request, id: offer,
         service_arrangement: {start_date: Date.today, end_date: 7.days.from_now}
    offer = assigns :offer
    assert offer.accepted?
    assert_redirected_to request
  end

  test "should delete to cancel when user is request owner" do
    offer = offers :two
    request = service_requests :one
    assert_difference 'ServiceArrangement.count', -1 do
      delete :cancel ,service_request_id: request, id: offer
    end
    offer = assigns :offer
    assert_not offer.accepted?
  end

  test "should delete to cancel when user is  offer owner" do
    user = users(:one)
    log_in_as user
    offer = offers :two
    request = service_requests :one

    assert_difference 'ServiceArrangement.count', -1 do
      delete :cancel ,service_request_id: request, id: offer
    end
    offer = assigns :offer
    assert_not offer.accepted?
  end

  test "should not delete to cancel when user is not offer owner neither reques owner" do
    user = users(:invalid)
    log_in_as user
    offer = offers :two
    request = service_requests :one

    assert_no_difference 'ServiceArrangement.count' do
      delete :cancel ,service_request_id: request, id: offer
    end
    assert_redirected_to root_url
  end
end
