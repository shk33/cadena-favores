class ServiceRequestsController < ApplicationController
before_action :logged_in_user, :get_notifications
before_action :set_usable_points, only: [:new, :create]

def index
  @usuarios = User.all
  busqueda = params[:busqueda]
  searchType = params[:searchType]
  if searchType == "tag"
    @peticionesFiltradas1 = ServiceRequest.searchByTag(busqueda)
    @peticionesFiltradas2 = ServiceRequest.searchByTag(busqueda).page(params[:page]).per(5)
  else
    @peticionesFiltradas1 = ServiceRequest.searchByTitle(busqueda)
    @peticionesFiltradas2 = ServiceRequest.searchByTag(busqueda).page(params[:page]).per(5)
  end
end

def show
    @usuarios = User.all
  busqueda = params[:busqueda]
  searchType = params[:searchType]
  if searchType == "tag"
    @peticionesFiltradas1 = ServiceRequest.searchByTag(busqueda)
    @peticionesFiltradas2 = ServiceRequest.searchByTag(busqueda).page(params[:page]).per(5)
  else
    @peticionesFiltradas1 = ServiceRequest.searchByTitle(busqueda)
    @peticionesFiltradas2 = ServiceRequest.searchByTag(busqueda).page(params[:page]).per(5)
  end
end

def new
	@service_request = ServiceRequest.new
  @tags = Tag.all
end

def create
  @creator = ServiceRequestCreation.new(service_request_params,
                                                current_user)
 
  respond_to do |format|
    if @creator.valid_creation?
      @service_request = @creator.create
      format.html { redirect_to @service_request, notice: 'Tu solicitud de servicio ha sido creada'}
    else
      @service_request = @creator.service_request
      @tags = Tag.all
      format.html { render :new }
    end
  end
end

private
  def service_request_params
    params.require(:service_request).permit({service_attributes: 
                                                [:title, 
                                                 :description, 
                                                 :cost]
                                            },
                                            { tag_ids: [] })
  end

  def set_usable_points
    @usable_points = current_user.balance.usable_points
  end

end
