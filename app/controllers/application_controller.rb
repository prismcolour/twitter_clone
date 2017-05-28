class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
  # Before filters
  # Confirms a logged-in user.
  # Method to fix security breaches for access to pages
  # User must be logged in
    def logged_in_user
      unless logged_in?
        # Stores location for friendly redirect when user not logged in
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
end
