class PointsTransaction < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :service_arrangement
  belongs_to :sender,   class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  #Model Validations
  validates :sender,   presence: true
  validates :receiver, presence: true
  validates :amount,   presence: true
  validates :service_arrangement, presence: true

  def transfer_points
    self.sender.balance.lost_points   self.amount
    self.receiver.balance.gain_points self.amount
  end

end