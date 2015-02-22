class ServiceRequest < ActiveRecord::Base
  #Relationships
  belongs_to :user #Obligatorio 
  has_one    :service, as: :serviceable #Obligatorio
  has_many   :offers #NO obligatorio
  has_and_belongs_to_many :tags #No obligatorio

  #Nested Attributes
  accepts_nested_attributes_for :service

  #Model Validations
  validates :service, presence: true
  validates :user,    presence: true
end