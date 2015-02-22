require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
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

  test "should not create service_request with negative cost" do
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

  test "should not create a valid service_request with a high cost" do
    #Intento crear un nuevo service request valido pero con
    # un costo alto
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "Este texto es valido",
        description: "Este texto tambien es valido",
        #Main user only has 400 points
        cost: "7000"
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
    educativa  = tags(:educativa).id
    transporte = tags(:transporte).id
    tags = [educativa, transporte]


    assert_difference 'ServiceRequest.count', 1 do 
      post :create, service_request: { service_attributes: {
        title: "Este texto es valido",
        description: "Este texto tambien es valido",
        cost: "100"
        }, tag_ids: tags }
    end
    #Debido a que la creacion del ServiceRequest fue exitosa
    #Entonces es el último registro en la bd
    service_request = ServiceRequest.last
    #Verifico que el usuario se le congelen sus puntos
    assert_equal 300, @user.balance.usable_points
    assert_equal 200, @user.balance.frozen_points
    assert_equal 500, @user.balance.total_points
    #Verifico que el ServiceRequest tenga los tags que deseo
    assert service_request.tag_ids.include? educativa
    assert service_request.tag_ids.include? transporte
    #Debe redireccionarme a mostrar el service request que acabo de crear
    assert_redirected_to service_request
  end

  test "should show a valid service_request" do
    service_request = service_requests(:one)
    service = service_request.service
    get :show, id: service_request
    assert_template :show
    assert_response :success
    assert_select 'strong', service.title
    assert_select 'span', "#{service.cost} puntos"
    assert_select 'p', service.description
    assert_select 'h3', 'Ofertas'
  end

  test "should get index" do
    tags = Tag.all
    get :index
    assert_response :success
    #Asserting advanced search form
    assert_select   'label', 'Busqueda por título'
    tags.each do |tag|
        assert_select 'label', tag.name
        assert_select "input", :name  => "tag", :value => tag.id
    end
    assert_select "input", :name  => "commit", :type => "submit",:value => 'Buscar'
  end

  test "should get index and search by tags" do
    request = service_requests(:one)
    get :index , tag: 1, search_type: 2
    assert_response :success
    assert_select 'a', request.service.title
  end

  test "should get index and search by name" do
    request = service_requests(:one)
    get :index , search: "mighty", search_type: 1
    assert_response :success
    assert_select 'a', request.service.title
  end

  test "should delete service request" do
    request = service_requests(:one)
    assert_difference 'ServiceRequest.count', -1 do
      assert_difference 'Service.count', -1 do
        delete :destroy , id: request.id
      end
    end
    assert_equal 401, @user.balance.usable_points
    assert_equal 99, @user.balance.frozen_points
    assert_equal 500, @user.balance.total_points
    assert_redirected_to my_service_requests_url
  end

  test "should not delete a service request if not belongs to owner" do
    request = service_requests(:two)
      assert_no_difference 'ServiceRequest.count' do
        assert_no_difference 'Service.count' do
          delete :destroy , id: request.id
        end
      end
    assert_redirected_to root_url
  end

  test "should not delete a service request if its closed" do
    request = service_requests(:main_closed)
      assert_no_difference 'ServiceRequest.count' do
        assert_no_difference 'Service.count' do
          delete :destroy , id: request.id
        end
      end
    assert_redirected_to root_url
  end

end
