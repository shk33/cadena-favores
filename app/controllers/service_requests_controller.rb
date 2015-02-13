class ServiceRequestsController < ApplicationController

def new
	@service_request = ServiceRequest.new
end

def create
	@service_request = ServiceRequest.new(service_request_params)

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
  	params.require(:service_request).permit( :user_id, {service_attributes: 
  											[:title, 
  											 :description, 
  											 :cost, "ServiceRequest"]})
  end
end
