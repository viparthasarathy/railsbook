class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable         
  validates :first_name, :last_name, presence: true

  has_many :posts
  has_many :created_posts, :class_name => "Post", :foreign_key => "creator_id"

  has_many :friend_requests
  has_many :incoming_friend_requests, :class_name => "FriendRequest", :foreign_key => "friend_id"

  has_many :initiated_friendships,  ->  { where(friend_requests: { approved: true }) }, :through => :friend_requests,          :source => :friend
  has_many :passive_friendships,    ->  { where(friend_requests: { approved: true }) }, :through => :incoming_friend_requests, :source => :user 

  has_many :pending_friendships,    ->  { where(friend_requests: { approved: false }) }, :through => :friend_requests,          :source => :friend
  has_many :requesting_friendships, ->  { where(friend_requests: { approved: false }) }, :through => :incoming_friend_requests, :source => :user 
  
  has_many :likes
  
  def friends
  	initiated_friendships | passive_friendships
  end

end