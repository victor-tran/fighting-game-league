class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.datetime :match_date
      t.integer :round_number
      t.integer :p1_id
      t.integer :p2_id
      t.integer :p1_score
      t.integer :p2_score
      t.integer :season_id
      t.integer :league_id

      t.timestamps
    end
  end
end
