class ServiceRequestsController < ApplicationController
def requests
end

def new
	@service_request = service_request.new
end

def create
	@service_request = service_request.new(service_request_params)
end

private
  def service_request_params
  	params.require(:service_request).permit( :user_id, {service_attributes: 
  											[:title, 
  											 :description, 
  											 :cost, @service_request.user_id, "ServiceRequest"]})
  end
end
