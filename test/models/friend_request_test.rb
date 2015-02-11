require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase

  def setup
    @user = users(:john)
    @alt_user = users(:mike)
  	@friend_request = FriendRequest.new(user_id: @user.id, friend_id: @alt_user.id, approved: false)
  end

  test "should be valid" do
  	assert @friend_request.valid?
  end

  test "should require user id" do
  	@friend_request.user_id = nil
  	assert_not @friend_request.valid?
  end

  test "should require friend id" do
  	@friend_request.friend_id = nil
  	assert_not @friend_request.valid?
  end

  test "should not have duplicate friend requests" do
  	@duplicate_request = @friend_request.dup
  	@friend_request.save
  	assert_not @duplicate_request.valid?
  end

  test "friend count should increase from approved request" do
    assert_difference [ '@user.reload.friends.count', '@alt_user.reload.friends.count'] do 
      @friend_request.update_attributes(approved: true)
    end
  end

end
