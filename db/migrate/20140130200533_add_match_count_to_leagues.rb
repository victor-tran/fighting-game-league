class AddMatchCountToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :match_count, :integer
  end
end
