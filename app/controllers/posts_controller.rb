class PostsController < ApplicationController
  
	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Your post has been created."
			redirect_to :back
		else
			flash[:error] = "Error with post creation."
			redirect_to :back
		end
	end

	def show
		@post = Post.find(params[:id])
	end

  def edit
  	@post = Post.find(params[:id])
  end

	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(post_params)
			flash[:success] = "Post successfully edited."
			redirect_to user_path(current_user)
		else
			flash[:error] = "Post was not updated."
			render 'new'
		end
	end

	def destroy
		@post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Post deleted."
    redirect_to :back
	end

	private


	def post_params
		params.require(:post).permit(:user_id, :content)
	end

end
