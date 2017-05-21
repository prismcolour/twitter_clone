class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in @user
      # remember user - ORIGINAL CODE/method call 
      # remember(user) from sessions helper file
      # replaced with the next line for 
      # boolean to take in the value for the checkbox 
      # if 1 remember user because user checked the box
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # redirect_to @user OLD CODE - updated with friendly forwarding
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # Fix for bug when user has multiple browser windows open
    # If logged out in one browser window cannot log out in
    # another browser window otherwise it will cause an error 
    # because there will be a second call to log_out where the
    # @current_user is missing inside the method
    # already logged out of application in the original browser window
    # subtle bug
    log_out if logged_in?
    redirect_to root_url
  end
end