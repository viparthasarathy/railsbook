class PostsController < ApplicationController
  
	def create
		@user = User.find(post_params[:user_id])
	  if current_user.friends.include?(@user) || @user == current_user
	  	@post = @user.posts.build(content: post_params[:content], creator: current_user)
		  if @post.save
			  flash[:success] = "Your post has been created."
			  redirect_to :back
		  else
			  flash[:error] = "Error with post creation."
			  redirect_to :back
		  end
		else
			flash[:error] = "You are not friends with this user."
			redirect_to :back
	  end
	end

	def show
		@post = Post.find(params[:id])
		@comments = @post.comments.all
		@comment = @post.comments.build
	end

  def edit
  	@post = Post.find(params[:id])
  	redirect_to root_url unless @post.creator == current_user
  end

	def update
		@post = Post.find(params[:id])
		if @post.creator == current_user 
		  if @post.update_attributes(content: post_params[:content])
			  flash[:success] = "Post successfully edited."
			  redirect_to current_user
		  else
			  flash[:error] = "Post was not updated."
			  render 'edit'
			end
	  else
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
	  	redirect_to root_url
	  end
	end

	def index
		ids = current_user.friends.map{ |friend| friend.id } << current_user.id
    @posts = Post.where(user_id: ids)
		@post = current_user.posts.build
	end

	private


	def post_params
		params.require(:post).permit(:user_id, :content)
	end

end
