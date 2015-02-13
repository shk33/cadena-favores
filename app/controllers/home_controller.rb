class HomeController < ApplicationController
  before_action :logged_in_user, :get_notifications

  def index 
  end
  
end
