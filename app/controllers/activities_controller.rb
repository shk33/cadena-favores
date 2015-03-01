class ActivitiesController < ApplicationController
  before_action :logged_in_user, :get_notifications
  before_action :set_activity, only: [:show]
  
  def index
    @activities = PublicActivity::Activity.order("created_at desc")
                  .where(recipient_id: current_user, recipient_type: "User")
    @activities.update_all read: true                  
  end

  def show
    if can_see_activity?
      @activity.update_attributes read: true
    else    
       redirect_to root_url
    end 
  end

  private
    def set_activity
      @activity = PublicActivity::Activity.find params[:id]
    end

    def can_see_activity?
      current_user == @activity.recipient
    end
end
