require 'test_helper'

class Site::SiteControllerTest < ActionController::TestCase

  test "should get landing page" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_select 'a[href=?]', signup_path, text: 'Regístrate', count: 4
    assert_select 'a[href=?]', login_path,  text: 'Ingresar',   count: 1
    assert_select "title", 'Cadena de Favores'
  end

end
