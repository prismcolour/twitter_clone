class User < ApplicationRecord
  attr_accessor :remember_token
  
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # Returns the hash digest of the given string/
  # Used in the test fixtures file to generate the hash password 
  # User.digest
  
  # Refactor
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  # Remembering users involves creating a remember token 
  # and saving the digest of the token to the database.
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in 
  # persistent sessions.  remember_digest is for the cookie
  # Returning a random token for the cookie - password generated
  # Then it needs to get hashed from User.digest via Bcrypt
  # Then it needs to get placed inside the remember_digest 
  # column in users table
  # token, hashed, put in table
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # Forgets a user for persistent session.
  # Undoes user.remember by updating the remember_digest with nil.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end