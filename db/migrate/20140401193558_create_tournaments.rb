class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :league_id
      t.integer :season_id
      t.string :participants, array: true
      t.integer :winner_id
      t.timestamps
    end
  end
end
