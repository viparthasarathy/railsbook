require 'test_helper'

class PostTest < ActiveSupport::TestCase


  def setup
    @user = users(:john)
    @alt_user = users(:mike)
  	@post = @user.posts.build(content: "blahblahblahblahblah", creator_id: @alt_user[:id])
  end

  test "should be valid" do
  	assert @post.valid?
  end

  test "should have content" do
  	@post.content = ""
  	assert_not @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "creator id should be present" do
    @post.creator_id = nil
    assert_not @post.valid?
  end

  test "most recent post should be first" do
    assert_equal Post.first, posts(:most_recent)
  end

  test "oldest post should be last" do
    assert_equal Post.last, posts(:oldest)
  end
  
end
