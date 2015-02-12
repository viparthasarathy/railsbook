require 'test_helper'

class PostTest < ActiveSupport::TestCase


  def setup
    @user = users(:john)
  	@post = @user.posts.build(content: "blahblahblahblahblah")
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
  
end
