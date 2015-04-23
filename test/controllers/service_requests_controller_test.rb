require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should get new" do
    get :new
    assert_template :new
    assert_select   'label', 'Título'
    assert_select   'label', 'Descripción'
    assert_select "input", :name  => "service_request[service_attributes][title]"
    assert_select "input", :name  => "service_request[service_attributes][description]"
    assert_select "input", :name  => "service_request[service_attributes][cost]"
    assert_select "input", :value => "Enviar"
  end

  test "should not create a invalid service_request" do
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "",
        description: "",
        cost: ""
        } }
    end
    assert_template :new
    assert_select 'div.alert-danger'
  end

  test "should not create service_request with negative cost" do
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "Este texto es valido",
        description: "Este texto tambien es valido",
        cost: "-200"
        } }
    end
    assert_template :new
    assert_select 'div.alert-danger'
  end

  test "should not create a valid service_request with a high cost" do
    assert_no_difference 'ServiceRequest.count' do 
      post :create, service_request: { service_attributes: {
        title: "Este texto es valido",
        description: "Este texto tambien es valido",
        #Main user only has 400 points
        cost: "7000"
        } }
    end
    assert_template :new
    assert_select 'div.alert-danger'
  end

  test "should create a valid service_request" do
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
    service_request = ServiceRequest.first
    assert_equal 300, @user.balance.usable_points
    assert_equal 200, @user.balance.frozen_points
    assert_equal 500, @user.balance.total_points
    assert service_request.tag_ids.include? educativa
    assert service_request.tag_ids.include? transporte
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
    tag = tags(:programacion)
    
    get :index , tag: tag.id, search_type: 2
    assert_response :success
    assert_select 'a', request.service.title
    assert_select 'span', tag.name
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

  test "should get edit" do
    request = service_requests(:one)
    get :edit, id: request.id
    assert_template :edit
    assert_select 'label', 'Título'
    assert_select 'label', 'Descripción'
    assert_select "input", :name  => "service_request[service_attributes][title]",
                   :value => request.service.title
    assert_select "input", :name  => "service_request[service_attributes][description]",
                   :value => request.service.description
    assert_select "input", :name  => "service_request[service_attributes][cost]",
                  :value => request.service.cost
    assert_select "input", :value => "Enviar"
  end

  test "should not get edit if user is not the owner" do
    request = service_requests(:two)
    get :edit, id: request.id
    assert_response :redirect
    assert_redirected_to root_url
  end
  
  test "should update a valid service_request with a higher cost" do
    request = service_requests(:one)

    educativa  = tags(:educativa).id
    transporte = tags(:transporte).id
    diseno     = tags(:diseno).id
    tags = [educativa, transporte]


    patch :update, id: request.id ,service_request: { service_attributes: {
      id: request.service.id,
      title: "Este texto es valido",
      description: "Este texto tambien es valido",
      cost: "101"
      }, tag_ids: tags }

    assert_equal 300, @user.balance.usable_points
    assert_equal 200, @user.balance.frozen_points
    assert_equal 500, @user.balance.total_points

    assert request.tag_ids.include? educativa
    assert request.tag_ids.include? transporte
    assert_not request.tag_ids.include? diseno
    assert_redirected_to request
  end  

  test "should update a valid service_request with a lower cost" do
    request = service_requests(:one)

    educativa  = tags(:educativa).id
    transporte = tags(:transporte).id
    diseno     = tags(:diseno).id
    tags = [educativa, transporte]


    patch :update, id: request.id ,service_request: { service_attributes: {
      id: request.service.id,
      title: "Este texto es valido",
      description: "Este texto tambien es valido",
      cost: "0"
      }, tag_ids: tags }

    assert_equal 401, @user.balance.usable_points
    assert_equal 99, @user.balance.frozen_points
    assert_equal 500, @user.balance.total_points

    assert request.tag_ids.include? educativa
    assert request.tag_ids.include? transporte
    assert_not request.tag_ids.include? diseno
    assert_redirected_to request
  end

  test "should not update a valid service_request if user is not the owner" do
    request = service_requests(:two)

    educativa    = tags(:educativa).id
    transporte   = tags(:transporte).id
    tags = [educativa, transporte]


    patch :update, id: request.id ,service_request: { service_attributes: {
      id: request.service.id,
      title: "Este texto es valido",
      description: "Este texto tambien es valido",
      cost: "0"
      }, tag_ids: tags }

    assert_redirected_to root_url
  end

  test "should not update an invalid service_request" do
    request = service_requests(:one)

    patch :update, id: request.id ,service_request: { service_attributes: {
      id: request.service.id,
      title: "",
      description: "",
      cost: "0"
      }, tag_ids: [] }

    assert_template :edit
  end

  test "should get user index" do
    get :user_index
    assert_response :success
  end

end
