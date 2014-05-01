class AddIndexesToPost < ActiveRecord::Migration
  def change
    add_index :posts, :league_id
    add_index :posts, :match_id
    add_index :posts, :bet_id
  end
end
