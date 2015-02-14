require 'test_helper'

class CommentPostInteractionTest < ActionDispatch::IntegrationTest
	include Warden::Test::Helpers

	def setup
		@user = users(:john)
		@alt_user = users(:mike)
		login_as(@alt_user)
		FriendRequest.create!(user: @user, friend: @alt_user, approved: true)
		@post = @user.posts.create!(content: "This is a post.", creator: @alt_user)
		5.times do 
		  @post.comments.create!(content: "Post.", user: @alt_user)
		end
	end

  test "posts on user page should show maximum of three comments" do
  	login_as(@user)
  	get user_path(@user)
  	assert_select 'p', text: "Post.", count: 3
  	assert_select 'p', text: "Mike Fisher", count: 4
  	assert_select 'a', text: "Edit", count: 0
  	assert_select 'a', text: "Delete", count: 4
  	assert_select 'a', text: "Comment"
  	assert_select 'a', text: "See All Comments"
  end

  test "post page should show all comments, submit comment form" do
  	login_as(@alt_user)
  	get user_path(@user)
  	assert_select 'a', text: "Comment"
  	assert_select 'a', text: "Edit", count: 4
    get post_path(@post)
    assert_select 'p', text: "Post.", count: 5
    assert_select 'p', text: "Mike Fisher", count: 5
    assert_select 'form' do 
    	assert_select "[value=?]", "Post Comment"
    end
    post comments_path, { comment: { content: "Post.", post_id: @post.id } }
    get post_path(@post)
    assert_select 'p', text: "Post.", count: 6
    assert_select 'a', text: "Edit", count: 7
    assert_select 'a', text: "Delete", count: 7
  end

  test "edit comment page should allow updating comment" do
  	login_as(@alt_user)
  	@comment = @alt_user.comments.last
  	get edit_comment_path(@comment)
  	assert_select 'form' do
  		assert_select "[value=?]", "Edit Comment"
  	end
  	put comment_path(@comment), { comment: { content: "Test." } } 
  	assert @comment.reload.content == "Test."
  	get post_path(@post)
  	assert_select 'p', text: "Post.", count: 4
  	assert_select 'p', text: "Test."
  	assert_select 'p', text: "Mike Fisher", count: 5
  end

end
