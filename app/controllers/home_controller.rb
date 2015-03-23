class HomeController < ApplicationController
  before_action :logged_in_user, :get_notifications

  def index 
  	@requests = ServiceRequest.get_suggested_services(current_user)
  end
  
end
