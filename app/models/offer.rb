class Offer < ActiveRecord::Base
  include PublicActivity::Common
  
  #Associations
  belongs_to :user
  belongs_to :service_request
  has_one    :service_arrangement

  #Model Validations
  validates :user,            presence: true
  validates :service_request, presence: true

  def accept params
    initialize_service_arrangement params
    if service_arrangement.save
      service_request.update_attributes open: false
      update_attributes accepted: true
      true
    else
      false
    end
  end

  def cancel request
    request.update_attributes open: true
    update_attributes accepted: false
    service_arrangement.destroy
  end

  def valid_acceptance? user
    request_open? && is_request_owner?(user)
  end

  def can_cancel_offer? user
    !service_arrangement.completed? && (is_request_owner?(user) || is_offer_owner?(user))
    #(is_request_owner?(user) || is_offer_owner?(user))
  end

  private
    def initialize_service_arrangement params
      service_arrangement  = ServiceArrangement.new params
      service_arrangement.client  = service_request.user
      service_arrangement.server  = user
      service_arrangement.service = service_request.service.dup
      service_arrangement.offer   = self
    end

    def request_open?
      service_request.open?
    end

    def is_request_owner? user
      user == service_request.user
    end

    def is_offer_owner? user
      user == self.user
    end

end
