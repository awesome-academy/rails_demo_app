class User < ApplicationRecord
  attr_accessor :remember_token

 has_many :microposts, dependent: :destroy

 has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower




  before_save {self.email = email.downcase}

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  has_secure_password


  def follow(other_user) # Follows a user.
    following << other_user # other user is as followed id
  end

  def unfollow(other_user) # Unfollows a user.
    following.delete(other_user)
  end

  def following?(other_user) # Returns if the current user is following the other_user or not
    following.include?(other_user)
  end


  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
         BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def feed
      Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end


end
