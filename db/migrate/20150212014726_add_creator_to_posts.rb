class AddCreatorToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :creator, index: true
    add_index :posts, [:creator_id, :created_at]
  end

end
