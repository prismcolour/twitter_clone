module SessionsHelper
  # Logs in the even user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session.
  # User gets a valid remember token for the cookie session
  # user id is encrypted from signed method
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  
  # Old code for temporary session
  # Returns the current logged-in user (if any).
  #def current_user
  #  @current_user ||= User.find_by(id: session[:user_id])
  #end
  
  # Persistent session using secure cookies
  # Returns the user corresponding to the remember token cookie.
  # Secure
  # This sets the current user in the session once authenticated and logged in
  # @current_user = user
  # Use this method when you need to set any method to use the current_user
  # Use this when you need current_user as an argument for other methods
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the given user is the current user.
  # Separate from setting the user to current_user when using cookies
  # This does not set the current user, but only checks that the user is the current user
  # Use this when you need to check if the user is the current user for CONTROL FLOW
  
  # current_user?(@user)
  # @user == current_user 
  # this will return true 
  # assert_equal @user, current_user
  
  def current_user?(user)
    user == current_user
  end
  
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
   # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
