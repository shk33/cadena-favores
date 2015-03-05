class Offer < ActiveRecord::Base
  include PublicActivity::Common
  
  #Associations
  belongs_to :user
  belongs_to :service_request
  has_one    :service_arrangement

  #Model Validations
  validates :user,            presence: true
  validates :service_request, presence: true

  attr_reader :arrangement

  def accept service_arrengement_params
    initialize_service_arrangement service_arrengement_params
    if @arrangement.save
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
  end

  def valid_acceptance? user
    request_open? && is_request_owner?(user)
  end

  def can_cancel_offer? user
    is_request_owner?(user) || is_offer_owner?(user)
  end

  private
    def initialize_service_arrangement params
      @arrangement = ServiceArrangement.new params
      @arrangement.client  = service_request.user
      @arrangement.server  = user
      @arrangement.service = service_request.service.dup
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
