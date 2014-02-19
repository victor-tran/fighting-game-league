class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :match_id
      t.integer :better_id
      t.integer :favorite_id

      t.timestamps
    end
  end
end
