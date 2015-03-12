class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :service_arrangement

  #Model Validations
  validates :rating, :inclusion => 1..5, presence: true
  validates :description, presence: true
  validates :service_arrangement, presence: true
  validates :user, presence: true
end
