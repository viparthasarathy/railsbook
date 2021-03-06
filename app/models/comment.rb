class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates :content, :user_id, :post_id, presence: true

  default_scope -> { order(created_at: :desc) }
end
