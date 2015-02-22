class ServiceRequest < ActiveRecord::Base
  #Relationships
  belongs_to :user
  has_one    :service, as: :serviceable, dependent: :destroy
  has_many   :offers
  has_and_belongs_to_many :tags

  #Nested Attributes
  accepts_nested_attributes_for :service

  #Model Validations
  validates :service, presence: true
  validates :user,    presence: true

  def self.search_by_title search
    if search
      ServiceRequest.joins(:service).where("title like ? ", "%#{search}%")
    else
      ServiceRequest.all
    end
  end

  def self.search_by_tag tag_id
    if tag_id
      ServiceRequest.joins(:tags).where(tags: {id: tag})
    else
      ServiceRequest.all
    end
  end  
  
end