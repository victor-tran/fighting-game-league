class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :commissioner_id
      t.integer :game_id
      t.integer :current_season_number
      t.integer :current_round
      t.boolean :started

      t.timestamps
    end
    
    add_index :leagues, :commissioner_id
  end
end
