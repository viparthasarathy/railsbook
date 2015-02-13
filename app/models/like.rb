class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :likeable_id, :scope => :user_id

  validates :user, :likeable, presence: true
end
