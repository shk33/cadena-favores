require 'test_helper'

class Site::SiteControllerTest < ActionController::TestCase

  test "should get landing page" do
    get :index
    assert_response :success
    assert_select "title", 'Cadena de Favores'
  end

end
