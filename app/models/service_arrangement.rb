class ServiceArrangement < ActiveRecord::Base
  has_one  :service,  as: :serviceable
end
