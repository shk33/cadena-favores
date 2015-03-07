class ServiceRequestsController < ApplicationController
before_action :logged_in_user, :get_notifications
before_action :set_usable_points,   only: [:new, :create, :edit]
before_action :set_service_request, only: [:show, :edit, :destroy]
before_action :set_tags,            only: [:index, :new, :edit]

def index
  # 1 = name
  # 2 = tags
  if params[:search_type] == '2'
    @service_requests = ServiceRequest.search_by_tag(params[:tag]).
                                            page(params[:page]).per(5)
  else
    @service_requests = ServiceRequest.search_by_title(params[:search]).
                                            page(params[:page]).per(5)
  end
end

def new
  @service_request = ServiceRequest.new
  @service_request.build_service
end

def create
  creator = ServiceRequestCreation.new(service_request_params,
                                                current_user)
  respond_to do |format|
    if creator.valid_creation?
      @service_request = creator.create
      flash[:success] = "Tu solicitud de servicio ha sido creada"
      format.html { redirect_to @service_request}
    else
      @service_request = creator.service_request
      @tags = Tag.all
      format.html { render :new }
    end
  end
end

def edit
  unless current_user == @service_request.user
    redirect_to root_url
  end
end

def update
  request = ServiceRequest.find params[:id]
  if !(current_user == request.user)
    redirect_to root_url
  else
    updater = ServiceRequestUpdater.new(request, service_request_params)
    respond_to do |format|
      if updater.valid_update?
        @service_request = updater.update
        format.html { redirect_to @service_request, notice: 'Tu solicitud de servicio ha sido actualizada'}
      else
        @service_request = updater.service_request
        set_tags
        set_usable_points
        format.html { render :edit }
      end
    end
  end

end

def show
  @service = @service_request.service
  @offer = Offer.new
end

def user_index
  @service_requests = current_user.service_requests.page(params[:page]).per(5)
end

def destroy
  destroyer = ServiceRequestDestroyer.new @service_request, current_user

  if destroyer.deleteable_request?
    destroyer.destroy
    redirect_to my_service_requests_url, notice: 'Se ha borrado exitosamente'
  else
    redirect_to root_url
  end
end

private
  def service_request_params
    params.require(:service_request).permit({service_attributes: 
                                                [:title, 
                                                 :id,
                                                 :description, 
                                                 :cost]
                                            },
                                            { tag_ids: [] })
  end

  def set_usable_points
    @usable_points = current_user.balance.usable_points
  end

  def set_service_request
    @service_request = ServiceRequest.find params[:id]
  end

  def set_tags
    @tags = Tag.all
  end

end