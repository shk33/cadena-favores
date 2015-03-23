require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do 
    @user = users(:main_user)
    log_in_as @user
  end

  test "should get new" do
    arrangement = service_arrangements :two
    get :new, service_arrangement_id: arrangement.id
    assert_template :new
    assert_select "input", :name  => "review[rating]"
    assert_select "input", :name  => "review[description]"
    assert_select "input", :value => "Calificar"
  end

  test "should not get new if user is not the client" do
    arrangement = service_arrangements :three
    get :new, service_arrangement_id: arrangement.id
    assert_redirected_to root_url
  end

  test "should not post create new if user is not the client" do
    arrangement = service_arrangements :three
    post :create, service_arrangement_id: arrangement.id, offer: {}
  end

  test "should post create " do
    arrangement = service_arrangements :two
    assert_difference 'Review.count', 1 do
      post :create, service_arrangement_id: arrangement.id, 
                  review: { rating: 4, description: "valid" }
    end
  end

  test "should not post create when review has invalid info" do
    arrangement = service_arrangements :two
    assert_no_difference 'Review.count' do
      post :create, service_arrangement_id: arrangement.id, 
                  review: { rating: 10, description: "valid" }
    end
  end

  test "should redirect to edit when get new and arrangement have a review" do
    arrangement = service_arrangements :four
    get :new, service_arrangement_id: arrangement.id
    assert_redirected_to edit_service_arrangement_review_path(arrangement, arrangement.review) 
  end

  test "should get edit" do
    arrangement = service_arrangements :four
    get :edit, service_arrangement_id: arrangement.id, id: arrangement.review.id
    assert_template :edit
  end

  test "should get edit when current user is not client" do
    log_in_as users(:one)
    arrangement = service_arrangements :four
    get :edit, service_arrangement_id: arrangement.id, id: arrangement.review.id
    assert_redirected_to root_url
  end

  test "should not update when current user is not client" do
    log_in_as users(:one)
    arrangement = service_arrangements :four
    post :update, service_arrangement_id: arrangement.id, 
                  id: arrangement.review.id, 
                  review: { rating: 4, description: "valid" } 
    assert_redirected_to root_url
  end

  test "should not update with invalid info" do
    arrangement = service_arrangements :four
    post :update, service_arrangement_id: arrangement.id,
                  id: arrangement.review.id, 
                  review: { rating: 10, description: "valid" } 
    assert_template :edit
  end

  test "should post update" do
    arrangement = service_arrangements :four
    post :update, service_arrangement_id: arrangement.id,
                  id: arrangement.review.id, 
                  review: { rating: 3, description: "Valid Valid" } 
    assert_redirected_to arrangement
  end

end
