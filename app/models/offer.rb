class Offer < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :user
  belongs_to :service_request
end
