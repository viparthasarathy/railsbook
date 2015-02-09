require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "home should redirect to sign in unless signed in" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should get home when signed in" do
  	@user = users(:john)
  	sign_in @user
    get             :index
    assert_response :success
  end

end
