require 'test_helper'

class PostTest < ActiveSupport::TestCase


  def setup
  	@post = Post.new(user_id: 1, content: "blahblahblahblahblah")
  end

  test "should be valid" do
  	assert @post.valid?
  end

  test "should belong to user" do
  	assert @post.user == User.find(1)
  end

  test "should have content" do
  	@post.content = ""
  	assert_not @post.valid?
  end
  
end
