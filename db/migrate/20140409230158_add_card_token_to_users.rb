class AddCardTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_card_id, :string
    add_column :users, :credit_card_description, :string
  end
end
