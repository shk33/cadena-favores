class ActivitiesController < ApplicationController
  before_action :logged_in_user, :get_notifications
  
  def index
    @activities = PublicActivity::Activity.order("created_at desc")
                  .where(recipient_id: current_user, recipient_type: "User")
  end

end
