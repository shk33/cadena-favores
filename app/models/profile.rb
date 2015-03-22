class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  mount_uploader :picture, PictureUploader

  validate  :picture_size

  def self.search_by_tag tag_id
    if tag_id
      Profile.joins(:tags).where(tags: {id: tag_id.to_i})
    else
      Profile.all
    end
  end

  private
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "debe ser menor a 5MB")
      end
    end
end
