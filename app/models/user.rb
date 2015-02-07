class User < ActiveRecord::Base
  #Assosications
  has_one   :profile
  has_one   :balance
  has_many  :service_requests #The services the user needs
  has_many  :offers
  has_many  :reviews
  has_many  :chat_rooms
  has_many  :chats, through: :chat_rooms
  has_many  :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy

  has_many  :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many  :following, through: :active_relationships, source: :followed
  has_many  :followers, through: :passive_relationships, source: :follower
  #Callbacks
  before_save   :downcase_email

  # Regexs for validatiosn
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #Model validations
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  #Attr Accessors
  attr_accessor :remember_token, :activation_token, :reset_token

  #Returns the not completed services that user hired
  def hired_services
    ServiceArrangement.where("client_id = ? AND completed = ?", self.id, false)
  end

  #Returns the not completed services that user needs to do
  def owed_services
    ServiceArrangement.where("server_id = ? AND completed = ?", self.id, false)
  end

  # Returns the hash digest of the given string.
  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Undo remember user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    def downcase_email
      self.email = email.downcase
    end
end