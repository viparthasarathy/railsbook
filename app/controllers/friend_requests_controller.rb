class FriendRequestsController < ApplicationController

  def create
    @friend_request = current_user.friend_requests.build(:friend_id => params[:friend_request][:friend_id], approved: false)
    if @friend_request.save 
      flash[:notice] = "Friend request sent."
      redirect_to :back
    else
      flash[:error] = "Unable to send friend request."
      redirect_to :back
    end
  end

  def update
    @friend_request = FriendRequest.where(:friend_id => current_user[:id], user_id: params[:id])
    if @friend_request.update(approved: true)
      flash[:notice] = "Friend confirmed."
      redirect_to root_url
    else
      flash[:error] =  "Unable to confirm friend."
      redirect_to root_url
    end
  end

  def destroy
    @friend_request = FriendRequest.where(friend_id: [current_user[:id], params[:id]]).where(user_id: [current_user[:id], params[:id]])
    @friend_request.destroy
    flash[:notice] = "Removed friend."
    redirect_to :back
  end

end
