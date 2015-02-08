class Tag < ActiveRecord::Base
  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :service_requests
end
