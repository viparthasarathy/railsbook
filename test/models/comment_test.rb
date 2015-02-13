require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
  	@user = users(:john)
  	@alt_user = users(:mike)
  	@post = @user.posts.create!(content: "I love testing.", creator: @user)
  	@comment = @post.comments.build(user: @alt_user, content: "Testing is stupid.")
  end

  test "should be valid" do
  	assert @comment.valid?
  end

  test "should have content" do
  	@comment.content = nil
  	assert_not @comment.valid?
  end

  test "should belong to a post" do
  	assert @comment.post == @post
  	@comment.post = nil
  	assert_not @comment.valid?
  end

  test "should belong to a user" do
  	assert @comment.user == @alt_user
  	@comment.user = nil
  	assert_not @comment.valid?
  end

end
