class AddFightBucksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fight_bucks, :integer
  end
end
