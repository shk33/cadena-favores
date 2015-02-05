class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :pictures, as: :imageable
end
