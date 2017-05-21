require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    # assert_template 'users/edit'
    # Updated test for friendly forwarding
    # TDD for redirect explained via 
    # http://stackoverflow.com/questions/30768657
    # /how-do-i-check-to-see-if-a-user-will-be-redirected-to-his-her-profile-after-logi
    assert_equal session[:forwarding_url], nil
    name  = "Foo Bar"
    email = "foo@bar.com"
    
    # Set pass to empty string in case user doesn't update pass
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    
    # Make sure updated info saves to database
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end