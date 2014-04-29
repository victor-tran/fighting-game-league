class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :action
      t.integer :postable_id
      t.string :postable_type

      t.timestamps
    end
    add_index :posts, [:postable_id, :postable_type]
  end
end
