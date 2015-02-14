class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]

  def index
  	redirect_to new_user_session_path unless user_signed_in?
  	redirect_to posts_path if user_signed_in?
  end
  
end
