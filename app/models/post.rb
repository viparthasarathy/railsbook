class Post < ActiveRecord::Base

	belongs_to :user
	belongs_to :creator,    :class_name => "User"
	
	has_many   :likes,      as: :likeable

	default_scope -> { order(created_at: :desc) }
	
	validates  :content,    presence: true
	validates  :user_id,    presence: true
	validates  :creator_id, presence: true

end
