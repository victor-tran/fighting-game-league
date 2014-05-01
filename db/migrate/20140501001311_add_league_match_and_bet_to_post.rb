class AddLeagueMatchAndBetToPost < ActiveRecord::Migration
  def change
    add_column :posts, :league_id, :integer
    add_column :posts, :match_id, :integer
    add_column :posts, :bet_id, :integer
  end
end
