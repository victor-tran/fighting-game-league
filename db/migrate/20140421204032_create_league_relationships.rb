class CreateLeagueRelationships < ActiveRecord::Migration
  def change
    create_table :league_relationships do |t|
      t.integer :league_id
      t.integer :follower_id

      t.timestamps
    end
    add_index :league_relationships, :league_id
    add_index :league_relationships, :follower_id
    add_index :league_relationships, [:league_id, :follower_id], unique: true
  end
end
