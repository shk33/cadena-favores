require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    log_in_as @user
  end

  #Pruebo que la vista de new
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
    #Verifico que el botón de input exista
    assert_select "input", :value => "Crear"
  end

  test "should not create a invalid service_request" do
    #Intento crear un nuevo service request invalido y verifico que
    # la cantidad de service request en la bd no cambie
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "",
        description: "",
        cost: ""
        } }
    end
    #Verifico que vuelva a renderizar el formulario el cual está en la vista new
    assert_template :new
    #Como falló su creación la app despliega una alerta que está dentro
    # del div alert-danger, verifico su presencia
    assert_select 'div.alert-danger'
  end

  test "should not create service_request with no numeric cost" do
    #Intento crear un nuevo service request invalido y verifico que
    # la cantidad de service request en la bd no cambie
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "Este texto es valido",
        description: "Este texto tambien es valido",
        cost: "-200"
        } }
    end
    #Verifico que vuelva a renderizar el formulario el cual está en la vista new
    assert_template :new
    #Como falló su creación la app despliega una alerta que está dentro
    # del div alert-danger, verifico su presencia
    assert_select 'div.alert-danger'
  end

  test "should create a valid service_request" do
      #Intento crear un nuevo service request valido y verifico que
      # la cantidad de service request en la bd sea +1
      assert_difference 'ServiceRequest.count', 1 do 
        post :create, service_request: { service_attributes: {
          title: "Este texto es valido",
          description: "Este texto tambien es valido",
          cost: "200"
          } }
      end
      #Debido a que la creacion del ServiceRequest fue exitosa
      #Entonces es el último registro en la bd
      service_request = ServiceRequest.last
      #Debe redireccionarme a mostrar el service request que acabo de crear
      assert_redirected_to service_request
  end

end
