require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get principal home page" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_select "title", 'Cadena de Favores'
  end

end
