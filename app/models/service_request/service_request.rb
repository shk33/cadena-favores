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
      ServiceRequest.joins(:service).where("LOWER(title) like ? ", "%#{search}%".downcase)
    else
      ServiceRequest.all
    end
  end

  def self.search_by_tag tag_id
    if tag_id
      ServiceRequest.joins(:tags).where(tags: {id: tag_id.to_i})
    else
      ServiceRequest.all
    end
  end

  def accepted_offer
    offers.where(accepted: true).first
  end

  def has_accepted_offer?
    offers.where(accepted: true).first.nil?
  end
  
end