class ServiceRequest < ActiveRecord::Base
  belongs_to :user #Obligatorio 
  has_one    :service, as: :serviceable #Obligatorio
  has_many   :offers #NO obligatorio
end
