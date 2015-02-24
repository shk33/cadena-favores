class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  mount_uploader :picture, PictureUploader
end
