class ServiceRequestsController < ApplicationController
before_action :logged_in_user

def new
	@service_request = ServiceRequest.new
end

def create
  @service_request = ServiceRequest.new(service_request_params)
	@service_request.user = current_user

	respond_to do |format|
		if @service_request.save
			format.html { redirect_to @service_request, notice: 'Tu solicitud de servicio ha sido creada'}
		else
			format.html { render :new }
		end
	end
end

private
  def service_request_params
  	params.require(:service_request).permit( 
                      {service_attributes: 
  											[:title, 
  											 :description, 
  											 :cost]
                      })
  end
end
