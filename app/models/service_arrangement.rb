class ServiceArrangement < ActiveRecord::Base
  include PublicActivity::Common
  #tracked except: :update, owner: ->(controller, model) { controller && controller.current_user }

  has_one  :service,  as: :serviceable
  has_one  :points_transaction
  has_one  :review
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :server, class_name: "User", foreign_key: "server_id"
end
