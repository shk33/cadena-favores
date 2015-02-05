class Service < ActiveRecord::Base
  belongs_to :serviceable, polymorphic: true
end
