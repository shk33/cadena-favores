class Offer < ActiveRecord::Base
  include PublicActivity::Common
  
  #Associations
  belongs_to :user
  belongs_to :service_request

  #Model Validations
  validates :user,            presence: true
  validates :service_request, presence: true

end
