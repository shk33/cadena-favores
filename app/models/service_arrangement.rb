class ServiceArrangement < ActiveRecord::Base
  has_one  :service,  as: :serviceable
  has_one  :points_transaction
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :server, class_name: "User", foreign_key: "server_id"
end
