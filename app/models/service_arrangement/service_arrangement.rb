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

  #Nested Atrributes
  accepts_nested_attributes_for :review


  def can_review? user
    is_client?(user) && !has_review? 
  end

  def self.user_calendar user
    user_services = user.hired_services
    user_services.merge(user.owed_services)
    user_services
  end
  
  private
    def has_review?
      !review.nil? && !review.new_record?
    end

    def is_client? user
      user == client
    end
end