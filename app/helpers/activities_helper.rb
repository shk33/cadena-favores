module ActivitiesHelper
  def get_notifications
    @notifications = current_user.notifications
  end
end
