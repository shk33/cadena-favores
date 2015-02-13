class Activity < ActiveRecord::Base

  def self.get_user_notifications user
    PublicActivity::Activity.order("created_at desc")
                  .where(recipient_id: user, recipient_type: "User").limit(5)
  end
  
end
