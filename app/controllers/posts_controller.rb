class PostsController < ApplicationController

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		if @post.save?
			flash[:success] = "Your post has been created."
			redirect_to @post
		else
			flash[:error] = "Error with post creation."
			render 'new'
		end
	end

	def show
		@post = Post.find(params[:id])

	end

	private


	def post_params
		params.require(:post).permit(:user_id, :content)
	end

end
