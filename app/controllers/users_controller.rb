class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
  	@post = current_user.posts.build
  	@posts = @user.posts.all
  end
end
