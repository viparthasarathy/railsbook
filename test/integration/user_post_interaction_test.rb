require 'test_helper'

class UserPostInteractionTest < ActionDispatch::IntegrationTest
	include Warden::Test::Helpers


  def setup
  	@user = users(:john)
  	@alt_user = users(:mike)
  	@third = users(:bob)
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

  test "users should be able to post on other users walls" do
   post_on_wall
  end

  test "users should not be able to edit posts on their wall unless creator" do
    post_on_wall
    login_as(@alt_user)
    @post = @alt_user.posts.last
    edit_without_permissions
  end

  test "users can destroy posts on their wall" do
    post_on_wall
    login_as(@alt_user)
    @post = @alt_user.posts.last
    delete_with_permissions
  end

  test "creators should be able to edit posts" do
    post_on_wall
    login_as(@user)
    get user_path(@alt_user)
    @post = @alt_user.posts.last
    assert_select 'a', text: "Edit"
    get edit_post_path(@post)
    assert_select 'form' do
    	assert_select "[value=?]", "Edit Post"
    end
    @post = @user.created_posts.last
    put post_path(@post), { post: {content: "Test." } }, { 'HTTP_REFERER' => 'http://localhost>3000/users/2' }
    get user_path(@alt_user)
    assert_select 'p', text: "Test."
  end

  test "creators can destroy their posts" do
  	post_on_wall
  	login_as(@user)
    @post = @alt_user.posts.last
    delete_with_permissions
  end

  test "unassociated users cannot edit posts on random walls" do
    post_on_wall
    login_as(@third)
    @post = @alt_user.posts.last
    edit_without_permissions
  end

  test "unassociated users cannot delete posts on random walls" do
  	post_on_wall
  	login_as(@third)
  	get user_path(@alt_user)
  	@post = @alt_user.posts.last
  	assert_select 'a', text: "Delete", count: 0
  	assert_no_difference ['Post.count', '@alt_user.reload.posts.count', '@user.reload.created_posts.count' ] do
  		delete post_path(@post), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
  	end
  	assert_redirected_to root_url
  end

  test "users should be able to like posts" do
    post_on_wall
    login_as(@third)
    get user_path(@alt_user)
    @post = @alt_user.posts.last
    assert_select 'a', text: "Like"
    assert_difference ['Like.count', '@post.reload.likes.count', '@third.reload.likes.count'] do
      post likes_path(post_id: @post[:id]), { likes: {likeable: @post, user: @third } }, {'HTTP_REFERER' => 'http://localhost:3000/users/2' } 
    end
    get user_path(@alt_user)
    @like = @third.likes.last
    assert_select 'a', text: "Unlike"
    assert_select 'p', text: "1 Like"
    assert_difference ['Like.count', '@post.reload.likes.count', '@third.reload.likes.count'], -1 do
      delete like_path(@like), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
    end
    get user_path(@alt_user)
    assert_select 'a', text: "Like"
    assert_select 'p', text: "0 Likes"
  end

  test "multiple users should be able to like posts" do
    post_on_wall
    login_as(@user)
    get user_path(@alt_user)
    @post = @alt_user.posts.last
    post likes_path(post_id: @post[:id]), { likes: {likeable: @post, user: @third } }, {'HTTP_REFERER' => 'http://localhost:3000/users/2' }
    logout
    login_as(@alt_user)
    get user_path(@alt_user)
    post likes_path(post_id: @post[:id]), { likes: {likeable: @post, user: @third } }, {'HTTP_REFERER' => 'http://localhost:3000/users/2' }
    get user_path(@alt_user)
    assert_select 'p', text: "2 Likes"
  end

  private

  def delete_with_permissions
    get user_path(@alt_user)
    assert_select 'a', text: "Delete"
    assert_difference ['Post.count', '@alt_user.reload.posts.count', '@user.reload.created_posts.count' ], -1 do
      delete post_path(@post), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
    end
    get user_path(@alt_user)
    assert_select 'p', text: "Lorem ipsum.", count: 0
  end

  def edit_without_permissions
  	get user_path(@alt_user)
  	assert_select 'a', text: "Edit", count: 0
  	get edit_post_path(@post)
  	assert_redirected_to root_url
  	get user_path(@alt_user)
  	put post_path(@post), { post: {content: "Test." } }, { 'HTTP_REFERER' => 'http://localhost>3000/users/2' }
  	assert_redirected_to root_url
  	get user_path(@alt_user)
  	assert_select 'p', text: "Lorem ipsum."
  end

  def post_on_wall
    FriendRequest.create(user: @user, friend: @alt_user, approved: true)
  	login_as(@user)
  	get user_path(@alt_user)
  	assert_select 'form' do
  		assert_select '[value=?]', "Post"
  	end
  	assert_difference ['@user.reload.created_posts.count', '@alt_user.reload.posts.count'] do
  		post posts_path, { post: { user_id: @alt_user[:id], content: "Lorem ipsum."} }, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
  	end
  	get user_path(@alt_user)
  	assert_select 'p', text: "Lorem ipsum."
  	get user_path(@user)
  	assert_select 'p', text: "Lorem ipsum.", count: 0
  	logout
  end
end
