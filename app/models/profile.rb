class Profile < ActiveRecord::Base
  belongs_to :user
  has_one  :picture,  as: :imageable
  has_and_belongs_to_many :tags
end
