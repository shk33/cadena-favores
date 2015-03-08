require 'test_helper'

class ServiceArrangementsControllerTest < ActionController::TestCase
  setup do
    @user = users(:main_user)
    log_in_as @user
  end

  test "should get hired" do
    get :hired
    assert_response :success
    arrangements = assigns :arrangements
    arrangements.each do |arrangement|
      assert_select "form", :action  => arrangement
    end
  end

  test "should get hired completed" do
    get :hired_completed
    assert_response :success
  end

  test "should not mark as completed if is not the client" do
    @arrangement = service_arrangements :three
    post :update, id: @arrangement
    assert_redirected_to root_url
  end

  test "should mark as completed if is the client" do
    @arrangement = service_arrangements :one
    post :update, id: @arrangement
    assert_redirected_to my_hired_completed_url
  end

  test "should show a valid service_arrangement" do
    service_request = service_requests(:one)
    service_arrangement = service_arrangements(:one)
    service = service_request.service
    get :show, id: service_arrangement
    assert_template :show
    assert_response :success
    assert_select 'h2', 'Detalles del servicio a realizar'
    assert_select 'label', 'Servidor'
    assert_select 'p', service_arrangement.server.name
    assert_select 'label', 'Fecha de inicio'
    assert_select 'p', service_arrangement.start_date.to_s
    assert_select 'label', 'Fecha de fin'
    assert_select 'p', service_arrangement.end_date.to_s
    assert_select 'a', service.title
    assert_select 'span', "#{service.cost} puntos"
    assert_select 'p', service.description
    service_request.tags.each do |tag|
        assert_select 'span', tag.name
    end
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'h2', 'Servicios a realizar'
    arrangements = assigns :arrangements
    arrangements.each do |arrangement|
        assert_select 'strong', arrangement.service.title
        assert_select 'p', arrangement.service.description
        assert_select 'strong', 'Usuario Contratado:'
        assert_select 'strong', 'Fecha de Inicio::'
        assert_select 'p', arrangement.start_date
        assert_select 'strong', 'Fecha de Entrega:'
        assert_select 'p', arrangement.end_date
        assert_select 'strong', 'Costo: '
        assert_select 'div', "#{arrangement.service.cost} puntos"
        assert_select 'label', tag.name
        assert_select "input", :type => "submit", :value => "Aceptar como Concluido"
        assert_select "input", :value => "Cancelar"
    end

  end

end
