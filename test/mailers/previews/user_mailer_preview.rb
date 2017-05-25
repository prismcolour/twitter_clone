# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # This should be previewing at http://michael-hartl-rails-tutorial-prismcolour.c9users.io and not
  # localhost:3000 because the host config was updated in 
  # config/environments/development.rb
  def account_activation
    # UserMailer.account_activation 
    
    # Updated code becaus account_activation method
    # needs a valid user
    # user variable equal to the first user in the development database
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  # This should be previewing at http://michael-hartl-rails-tutorial-prismcolour.c9users.io and not
  # localhost:3000 because the host config was updated in 
  # config/environments/development.rb
  def password_reset
    UserMailer.password_reset
  end
  
  # Preview email is working now
  # https://michael-hartl-rails-tutorial-prismcolour.c9users.io/rails/mailers/user_mailer/account_activation
  # http://michael-hartl-rails-tutorial-prismcolour.c9users.io/rails/mailers/user_mailer/account_activation.txt

# Preview this email at
  # http://michael-hartl-rails-tutorial-prismcolour.c9users.io/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
  
end
