class ServiceRequest < ActiveRecord::Base
  belongs_to :user
  has_one    :service, as: :serviceable
  has_many   :offers
end
