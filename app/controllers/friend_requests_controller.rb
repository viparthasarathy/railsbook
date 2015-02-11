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
    @friend_request = FriendRequest.find(params[:id])
    if @friend_request.update_attributes(approved: true)
      flash[:notice] = "Friend confirmed."
      redirect_to :back
    else
      flash[:error] =  "Unable to confirm friend."
      redirect_to :back
    end
  end

  def destroy
    FriendRequest.destroy(params[:id])
    flash[:notice] = "Removed friend."
    redirect_to :back
  end

  def index
    @incoming_requests = current_user.requesting_friendships.all
    @outgoing_requests = current_user.pending_friendships.all
  end
end
