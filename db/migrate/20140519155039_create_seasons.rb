class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :league_id
      t.integer :number
      t.boolean :current_season
      t.integer :fighters, array: true, default: []

      t.timestamps
    end
  end
end
