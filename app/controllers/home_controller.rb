class HomeController < ApplicationController
  before_action :logged_in_user, :get_notifications

  def index 
  	@suggestedServiceRequests = Array.new()
  	@suggestedServiceRequests = User.get_suggested_services(current_user.id)

  	@suggestedUsers = Array.new
  	@suggestedUsers = User.get_suggested_users(current_user.id)

  end
  
end
