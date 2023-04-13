class CreateFollowings < ActiveRecord::Migration[7.0]
  def change
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.integer :status, limit: 1, default: 0

      t.timestamps
    end

    add_index :followings, :follower_id
    add_index :followings, :followed_id
    add_index :followings, :status
  end
end
