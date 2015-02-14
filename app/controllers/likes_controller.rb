class LikesController < ApplicationController
  def create
  	@post = Post.find(params[:post_id])
  	@like = @post.likes.build(user: current_user)
  	if @like.save
  		flash[:success] = "Liked."
  		redirect_to :back
  	else
  		flash[:error] = "Error."
  		redirect_to :back
  	end
  end


  def destroy
  	@like = Like.find(params[:id])
  	@like.destroy
  	redirect_to :back
  end
end
