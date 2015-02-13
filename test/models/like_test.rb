require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
  	@user = users(:john)
  	@post = @user.posts.create!(content: "Lorem ipsum.", creator_id: @user.id)
  	@like = @post.likes.build(user_id: @user.id)
  end

  test "is valid" do
  	assert @like.valid?
  end

  test "belongs to a user" do
  	assert @like.user == @user
  	@like.user = nil
  	assert_not @like.valid?
  end

  test "belongs to a likeable" do
  	assert @like.likeable == @post
  	@like.likeable = nil
  	assert_not @like.valid?
  end

  test "user cannot like same likeable twice" do
  	@alt_like = @like.dup
  	@like.save
  	assert_not @alt_like.valid?
  end
end

