class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :user_posts, [:user_id, :created_at]
  end
end
