class HomeController < ApplicationController
  before_action :logged_in_user, :get_notifications

  def index 
  	@suggested_requests = ServiceRequest.get_suggested_services(current_user)
  	@suggested_users    = current_user.get_suggested_users
  end
  
end
