class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  mount_uploader :picture, PictureUploader

  validate  :picture_size

  private
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "debe ser menor a 5MB")
      end
    end
end
