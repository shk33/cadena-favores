class ServiceArrangement < ActiveRecord::Base
  include PublicActivity::Common

  #Associations
  has_one  :service,  as: :serviceable
  has_one  :points_transaction
  has_one  :review
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :server, class_name: "User", foreign_key: "server_id"
  belongs_to :offer

  #Model Validations
  validates :client,     presence: true
  validates :server,     presence: true
  validates :end_date,   presence: true
  validates :start_date, presence: true
  validates :offer,      presence: true
  validate :start_date_cannot_be_in_the_past,
    :end_date_cannot_be_in_past_of_start_date

  #Nested Atrributes
  accepts_nested_attributes_for :review


  def start_date_cannot_be_in_the_past
    errors.add(:start_date, "can't be in the past") if 
      !start_date.blank? && start_date < Date.today
  end

  def end_date_cannot_be_in_past_of_start_date
    errors.add(:end_date, "can't be less than start date") if
      !start_date.blank? && !end_date.blank? && start_date > end_date
  end

  def can_review? user
    is_client?(user) && !has_review? 
  end

  def self.user_calendar user
    user.hired_services + user.owed_services
  end
  
  def has_review?
    !review.nil? && !review.new_record?
  end
  
  private
    def is_client? user
      user == client
    end
end