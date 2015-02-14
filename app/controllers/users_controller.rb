class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
  	@post = @user.posts.build
  	@posts = @user.posts.all
  end

  def index
  	@users = User.all
  end
  
end
