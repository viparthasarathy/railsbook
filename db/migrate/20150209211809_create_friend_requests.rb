class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :user_id
      t.integer :friend_id
      t.boolean :approved

      t.timestamps
    end

    add_index :friend_requests, :user_id
    add_index :friend_requests, :friend_id
    add_index :friend_requests, [:user_id, :friend_id], unique: true
  end
end
