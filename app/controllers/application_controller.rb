class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ActivitiesHelper
  include PublicActivity::StoreController

  private

    def send_notification user_id, notification_type 
      begin  
        Pusher['private-'+user_id.to_s].trigger( notification_type, {:id => PublicActivity::Activity.last.id})
      rescue  
        puts 'Could not sen the real time notifications.'  
      end 
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def have_account
      if logged_in?
        redirect_to root_url
      end
    end

end
