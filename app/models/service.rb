class Service < ActiveRecord::Base
  #Relationships
  belongs_to :serviceable, polymorphic: true

  #Model Validations
  validates :title,       presence: true
  validates :description, presence: true
  validates :cost, presence: true, numericality: { only_integer: true }
end
