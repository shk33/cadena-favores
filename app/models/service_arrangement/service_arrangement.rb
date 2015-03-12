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

end