require 'test_helper'

class UserTest < ActiveSupport::TestCase


  def setup
    @user = User.new(first_name: "Bob", last_name: "Po", email: "bobpo@gmail.com", 
         password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "user should have a first name" do
    @user.first_name = ""
    assert_not @user.valid?
  end

  test "user should have a last name" do
    @user.last_name = ""
    assert_not @user.valid?
  end

end
