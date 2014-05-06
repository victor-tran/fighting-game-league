class AddIndexesToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, :user_id
    add_index :memberships, :league_id
    add_index :memberships, [:user_id, :league_id], unique: true
  end
end
