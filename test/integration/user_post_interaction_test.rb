require 'test_helper'

class UserPostInteractionTest < ActionDispatch::IntegrationTest
	include Warden::Test::Helpers


  def setup
  	@user = users(:john)
  end

  test "user should be able to create posts" do
  	login_as(@user)
  	get user_path(@user)
  	assert_select 'form' do 
  		assert_select ["value=?"], "Post"
  	end
    assert_difference ['Post.count', '@user.reload.posts.count'] do
    	post posts_path, { post: {user_id: @user[:id], content: "Lorem ipsum blahblahblah." } }, { 'HTTP_REFERER' => 'http://localhost:3000/users/1'}
    end


  end
end
