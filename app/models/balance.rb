class Balance < ActiveRecord::Base
  belongs_to :user

  def enough_points_for_request? request_points
    self.usable_points >= request_points
  end

  def freeze_points points
    self.usable_points -= points
    self.frozen_points += points
    self.save
  end

  def unfreeze_points points
    self.usable_points += points
    self.frozen_points -= points
    self.save
  end

end
