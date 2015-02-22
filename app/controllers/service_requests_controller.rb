class ServiceRequestsController < ApplicationController
before_action :logged_in_user, :get_notifications
before_action :set_usable_points, only: [:new, :create]

def index
  # 1 = name
  # 2 = tags
  if params[:search_type] == 2
    @service_requests = ServiceRequest.search_by_tag(params[:tag]).
                                            page(params[:page]).per(5)
  else
    @service_requests = ServiceRequest.search_by_title(params[:search]).
                                            page(params[:page]).per(5)
  end
  @tags = Tag.all
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

def show
  @service_request = ServiceRequest.find params[:id]
  @service = @service_request.service
  @offer = Offer.new
end

def user_index
  @service_requests = current_user.service_requests.page(params[:page]).per(5)
end

def destroy
  if service_requests_owner?
    ServiceRequest.find(params[:id]).destroy
    redirect_to my_service_requests_url, notice: 'Se ha borrado exitosamente'
  else
    redirect_to root_url
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

  def service_requests_owner?
    current_user == ServiceRequest.find(params[:id]).user
  end
end