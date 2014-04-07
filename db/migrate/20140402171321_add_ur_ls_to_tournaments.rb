class AddUrLsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :live_image_url, :string
    add_column :tournaments, :full_challonge_url, :string
  end
end
