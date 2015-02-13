class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :likeable, polymorphic: true, index: true
      t.timestamps
    end

    add_index :likes, [:user_id, :likeable_id], :unique => true
  end
end
