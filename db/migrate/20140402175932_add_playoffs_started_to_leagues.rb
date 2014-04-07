class AddPlayoffsStartedToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :playoffs_started, :boolean
  end
end
