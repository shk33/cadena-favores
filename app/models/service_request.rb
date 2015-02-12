class ServiceRequest < ActiveRecord::Base
  belongs_to :user #Obligatorio 
  has_one    :service, as: :serviceable #Obligatorio
  has_many   :offers #NO obligatorio
  has_and_belongs_to_many :tags #No obligatorio
  accepts_nested_attributes_for :service
end
