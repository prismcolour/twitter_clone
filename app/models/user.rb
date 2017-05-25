class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
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
  # def authenticated?(remember_token)
    # Bug fix for when user has different browsers open and 
    # logs out of one browser while still being logged in 
    # another browser.  The open browser will still have the user_id
    # cookie and if they relaunch the browser, there is a mismatch of 
    # remember_digest and remember_token in the authentication?
    # method causing a raise (fail/exception) 
    # This returns false and stops code execution if there's the 
    # user.id does not have a digest that got deleted from logging out
    # of the first browoser to match against the token 
    # You cannot have remember_digest be nil when it goes into the Brcrypt
    # method to match the token with the digest, it will cause an error

    # return false if remember_digest.nil?
    # BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # end
  
  # Returns true if the given token matches the digest.
  # Generalized authenticated model so that account activation can also it
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user for persistent session.
  # Undoes user.remember by updating the remember_digest with nil.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Account activation methods
  
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end