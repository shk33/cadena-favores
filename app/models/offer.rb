class Offer < ActiveRecord::Base
  include PublicActivity::Common
  
  #Associations
  belongs_to :user
  belongs_to :service_request

  #Model Validations
  validates :user,            presence: true
  validates :service_request, presence: true

  attr_reader :arrangement

  def accept service_arrengement_params
    initialize_service_arrangement service_arrengement_params
    if @arrangement.save
      service_request.update_attributes open: false
      true
    else
      false
    end
  end

  private
    def initialize_service_arrangement params
      @arrangement = ServiceArrangement.new params
      @arrangement.client  = service_request.user
      @arrangement.server  = user
      @arrangement.service = service_request.service.dup
    end
end
