class PostsController < ApplicationController
  
	def create
		@user = User.find(post_params[:user_id])
		@post = @user.posts.build(post_params)
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
  	flash[:error] = "You do not have permission to edit this post."
  	redirect_to root_url unless @post.creator == current_user
  end

	def update
		@post = Post.find(params[:id])
		if @post.creator == current_user
		  if @post.update_attributes(post_params)
			  flash[:success] = "Post successfully edited."
			  redirect_to :back
		  else
			  flash[:error] = "Post was not updated."
			  render 'new'
			end
	  else
	  	flash[:error] = "You do not have permission to edit this post."
	  	redirect_to root_url
		end
	end

	def destroy
		@post = Post.find(params[:id])
		if @post.creator == current_user || @post.user == current_user
	    @post.destroy
	    flash[:success] = "Post deleted."
	    redirect_to :back
	  else
	  	flash[:error] = "You do not have permission to delete this post."
	  	redirect_to root_url
	  end
	end

	private


	def post_params
		params.require(:post).permit(:user_id, :creator_id, :content)
	end

end
