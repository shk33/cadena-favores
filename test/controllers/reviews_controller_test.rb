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

end
