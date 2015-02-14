require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

	def setup
		@user = users(:john)
		@alt_user = users(:mike)
		@third_user = users(:bob)
		@post = @user.posts.create!(content: "Test", creator: @user)
	end

	test "should redirect comment when user is not friends with post user" do
		sign_in @alt_user
		assert_no_difference ['Comment.count', '@post.reload.comments.count', '@alt_user.reload.comments.count'] do
			post :create, comment: {  content: "Lorem ipsum", post_id: @post[:id] }
		end
		assert_redirected_to root_url
	end

	test "should create comment when user is friends with post user" do
		sign_in @alt_user
		@alt_user.friend_requests.create!(friend: @user, approved: true)
		assert_difference ['Comment.count', '@post.reload.comments.count', '@alt_user.reload.comments.count'] do
			post :create, comment: {  content: "Lorem ipsum", post_id: @post[:id] }
		end
		assert_redirected_to @post
	end

	test "should redirect destroy when user is not comment creator or wall owner" do
		sign_in @alt_user
		@alt_user.friend_requests.create!(friend: @user, approved: true)
		post :create, comment: {  content: "Lorem ipsum", post_id: @post[:id] }
		@comment = @alt_user.comments.last
		sign_out @alt_user
		sign_in @third_user
		assert_no_difference ['Comment.count', '@post.reload.comments.count', '@alt_user.reload.comments.count'] do
			delete :destroy, id: @comment
		end
		assert_redirected_to root_url
	end

	test "should destroy comment when user is wall owner or creator" do
		sign_in @alt_user
		@alt_user.friend_requests.create!(friend: @user, approved: true)
		post :create, comment: {  content: "Lorem ipsum", post_id: @post[:id] }
		@comment = @alt_user.reload.comments.first
		post :create, comment: {  content: "Ipsum lorem", post_id: @post[:id] }
		@comment_2 = @alt_user.reload.comments.first
		assert_difference ['Comment.count', '@post.reload.comments.count', '@alt_user.reload.comments.count'], -1 do
			delete :destroy, id: @comment
		end
		sign_out @alt_user
		sign_in @user
		assert_difference ['Comment.count', '@post.reload.comments.count', '@alt_user.reload.comments.count'], -1 do
			delete :destroy, id: @comment_2
		end
	end

	test "only comment creator should be able to edit" do
		sign_in @alt_user
		@alt_user.friend_requests.create!(friend: @user, approved: true)
		post :create, comment: { content: "Lorem ipsum", post_id: @post }
		@comment = @alt_user.comments.last
		patch :update, id: @comment, comment: { content: "Edited." }
		assert @comment.reload.content == "Edited."
		sign_out @alt_user
		sign_in @user
		patch :update, id: @comment, comment: { content: "Not edited." }
    assert_redirected_to root_url
    assert @comment.reload.content == "Edited."
	end

end
