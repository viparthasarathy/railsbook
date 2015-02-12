require 'test_helper'

class FriendingTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup 
  	@user = users(:john)
  	@alt_user = users(:mike)
  end

  test "user should not see friend-related activities for self" do
    login_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'form', count: 1
  end

  test "user should be able to create and cancel friend requests" do
  	create_request
  	login_as(@user)
  	get user_path(@alt_user)
  	assert_select 'form' do
  	  assert_select "[value=?]", "Cancel Request"
  	end
  	friend_request = @user.friend_requests.find_by(friend_id: @alt_user.id)
  	assert_difference 'FriendRequest.count', -1 do
  	  delete friend_request_path(friend_request), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
  	end
  end

  test "alt user should be able to accept friend requests and end friendship" do
    create_request
  	login_as(@alt_user)
  	get user_path(@user)
    assert_select 'form' do
      assert_select "[value=?]", "Accept Request"
    end
    friend_request = @user.friend_requests.find_by(friend_id: @alt_user.id)
    assert_difference '@alt_user.reload.friends.count', 1 do
      put friend_request_path(friend_request), { friend_request: {user_id: 1, friend_id: 2, approved: true } }, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
    end
    get user_path(@user)
    assert_select 'form' do
      assert_select "[value=?]", "Remove Friend"
    end
    assert_difference '@alt_user.reload.friends.count', -1 do
      delete friend_request_path(friend_request), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
    end
  end

  test "alt user should be able to decline friend requests" do
  	create_request
  	login_as(@alt_user)
  	get user_path(@user)
  	assert_select 'form' do
  	  assert_select "[value=?]", "Decline Request"
  	end
  	friend_request = @user.friend_requests.find_by(friend_id: @alt_user.id)
  	assert_no_difference '@alt_user.reload.friends.count' do
  	  delete friend_request_path(friend_request), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/1' }
  	end
  end

  test "user should be able to remove friendship" do
    friend_request = FriendRequest.new(user_id: @user.id, friend_id: @alt_user.id, approved: true)
    friend_request.save
    login_as(@user)
    get user_path(@alt_user)
    assert_select 'form' do
      assert_select "[value=?]", "Remove Friend"
    end
    assert_difference '@user.reload.friends.count', -1 do
    	delete friend_request_path(friend_request), {}, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
    end
  end

  private

  def create_request
  	login_as(@user)
  	get user_path(@alt_user)
  	assert_template 'users/show'
  	assert_select 'form' do
  	  assert_select "[value=?]", "Add Friend"
  	end
    assert_difference 'FriendRequest.count', 1 do
  	  post friend_requests_path, { friend_request: {user_id: 1, friend_id: 2, approved: false } }, { 'HTTP_REFERER' => 'http://localhost:3000/users/2' }
  	end
  	logout	
  end


end
