require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    log_in_as @user
  end

  #Pruebo que la vista de 
  test "should get new" do
    get :new
    #Verifico que renderiza la vista new
    assert_template :new
    #Verifico que están los labels de la vista
    assert_select   'label', 'Título'
    assert_select   'label', 'Descripción'
    assert_select   'label', 'Costo en Puntos'
    #Verifico la existencia de los inputs
    assert_select "input", :name  => "service_request[service_attributes][title]"
    assert_select "input", :name  => "service_request[service_attributes][description]"
    assert_select "input", :name  => "service_request[service_attributes][cost]"
    assert_select "input", :value => "Crear"

  end
end
