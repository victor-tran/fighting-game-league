class AddUuidAndConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :string
    add_column :users, :confirmed, :boolean
  end
end
