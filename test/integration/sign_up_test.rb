require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest

  test "valid signup information" do
  	get new_user_registration_path
  	assert_difference 'User.count', 1 do
  	  post_via_redirect user_registration_path, user: {email:         "user@example.com",
  	  	                                               first_name:                "Mike",
  	  	                                               last_name:                "Fisher",
  	                                                   password:              "password",
  	                                                   password_confirmation: "password"}
  	end
  	assert_template 'posts/index'
  end

  test "invalid signup information" do
  	get new_user_registration_path
  	assert_no_difference 'User.count' do
  	  post_via_redirect user_registration_path, user: {email:                "no@no",
  	                                                   first_name:               "",
  	                                                   last_name:                "",
  	                                                   password:              "foo",
  	                                                   password_confirmation: "bar"}
  	end
  	assert_template 'devise/registrations/new'
  end
end
