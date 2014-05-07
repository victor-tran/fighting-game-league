class AddSubjectableToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :league_id, :integer
    remove_column :posts, :match_id, :integer
    remove_column :posts, :bet_id, :integer
    add_column :posts, :subjectable_id, :integer
    add_column :posts, :subjectable_type, :string
    add_index :posts, [:subjectable_id, :subjectable_type]
  end
end
