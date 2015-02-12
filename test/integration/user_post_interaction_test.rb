require 'test_helper'

class UserPostInteractionTest < ActionDispatch::IntegrationTest
	include Warden::Test::Helpers


  def setup
  	@user = users(:john)
  end

  test "user should be able to create, update, and destroy posts" do
  	login_as(@user)
  	get user_path(@user)
  	assert_select 'form' do 
  		assert_select "[value=?]", "Post"
  	end
  	assert_select 'p', text: "No Posts" 
    assert_difference ['Post.count', '@user.reload.posts.count'] do
    	post posts_path, { post: {user_id: @user[:id], content: "Lorem ipsum." } }, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
    end
    get user_path(@user)
    assert_select 'p', text: "Lorem ipsum."
    @post = @user.posts.last 
    assert_select 'a', text: "Edit"
    get edit_post_path(@post)
    assert_select 'form' do
    	assert_select "[value=?]", "Edit Post"
    end
    put post_path(@post), { post: {content: "Test." } }, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
    get user_path(@user)
    assert_select 'p', text: "Test." 
    assert_select 'a', text: "Delete"
    assert_difference ['Post.count', '@user.reload.posts.count'], -1 do
    	delete post_path(@post), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
    end
  end



end
