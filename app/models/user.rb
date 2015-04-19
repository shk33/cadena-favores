class User < ActiveRecord::Base
  #Assosications
  has_one   :profile, autosave: true, dependent: :destroy
  has_one   :balance, autosave: true, dependent: :destroy
  has_many  :service_requests #The services the user needs
  has_many  :offers
  has_many  :reviews
  has_many  :chat_rooms
  has_many  :chats, through: :chat_rooms
  has_many  :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy

  has_many  :sent_transactions,    class_name:  "PointsTransaction",
                                  foreign_key: "sender_id"
  has_many  :received_transactions,class_name:  "PointsTransaction",
                                  foreign_key: "receiver_id"
  has_many  :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many  :following, through: :active_relationships, source: :followed
  has_many  :followers, through: :passive_relationships, source: :follower
  #Callbacks
  before_save       :downcase_email
  before_validation :add_balance, on: :create
  before_validation :add_profile, on: :create

  #Nested Atrributes
  accepts_nested_attributes_for :balance, :profile

  # Regexs for validatiosn
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #Model validations
  validates :name,    presence: true, length: { maximum: 50 }
  validates :profile, presence: true
  validates :balance, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  #Attr Accessors
  attr_accessor :remember_token, :activation_token, :reset_token

  def hired_services_completed
    ServiceArrangement.where("client_id = ? AND completed = ?", self.id, true)
  end
  

  def services_completed
    ServiceArrangement.where("server_id = ? AND completed = ?", self.id, true)
  end

  def last_services_completed
    ServiceArrangement.where("server_id = ? AND completed = ?", self.id, true).take(3)
  end

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

  #Get all notifications of user
  def notifications
    Activity.get_user_notifications self
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  def has_enough_points? points
    self.balance.enough_points_for_request? points
  end

  def self.search_by_name search
    if search
      User.where("LOWER(name) like ? ", "%#{search}%".downcase)
    else
      User.all
    end
  end

  def self.search_by_tag tag_id
    if tag_id
      User.joins(:profile).
           joins('INNER JOIN profiles_tags ON profiles_tags.profile_id = profiles.id').
           where('tag_id = ?', tag_id.to_i)
    else
      User.all
    end
  end
  
  def get_suggested_users
    not_following.take(3)
  end

  def not_following
    User.all - following
  end

  private
    def downcase_email
      self.email = email.downcase
    end

    def add_profile
      self.profile = Profile.create
    end

    def add_balance
      self.balance = Balance.create total_points: 10, usable_points: 10
    end
end