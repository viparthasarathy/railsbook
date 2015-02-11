class FriendRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user_id,   presence: true
  validates :friend_id, presence: true, :uniqueness => { :scope => :user_id, :message => "Cannot friend request same person multiple times." }
end
