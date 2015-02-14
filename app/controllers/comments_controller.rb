class CommentsController < ApplicationController

  def create
  	@post = Post.find(comment_params[:post_id])
    if current_user.friends.include?(@post.user) || current_user == @post.user
      @comment = @post.comments.build(content: comment_params[:content], user: current_user)
      if @comment.save
      	flash[:success] = "Commented."
      	redirect_to @post
      else
      	flash[:error] = "Could not comment."
      	render @post
      end
    else
    	flash[:error] = "You do not have permission to comment on this post."
    	redirect_to root_url
    end
  end


  def destroy
  	@comment = Comment.find(params[:id])
  	@post = @comment.post
  	if current_user == @comment.user || current_user == @post.user
  		@comment.destroy
  		flash[:success] = "Comment deleted."
  		redirect_to @post
  	else
  		flash[:error] = "You do not have permission to delete this post."
  		redirect_to root_url
  	end
  end

  def edit
  	@comment = Comment.find(params[:id])
  end

  def update
  	@comment = Comment.find(params[:id])
  	if current_user == @comment.user
  		if @comment.update_attributes(content: comment_params[:content])
  			flash[:success] = "Comment updated."
  			redirect_to @comment.post
  		else
  			flash[:error] = "Error updating comment."
  			render 'edit'
  		end
  	else
  		flash[:error] = "You are not the owner of this comment."
  		redirect_to root_url
  	end
  end


  private

  def comment_params
  params.require(:comment).permit(:post_id, :content)
  end

end
